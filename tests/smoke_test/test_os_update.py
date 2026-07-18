import json
import logging
from time import sleep

import pytest

_LOGGER = logging.getLogger(__name__)


@pytest.mark.dependency()
@pytest.mark.timeout(120)
def test_init(shell, shell_json):
    def check_container_running(container_name):
        out = shell.run_check(
            f"docker container inspect -f '{{{{.State.Status}}}}' {container_name} || true"
        )
        return "running" in out

    # wait for important containers first
    while True:
        if check_container_running("homeassistant") and check_container_running("hassio_supervisor"):
            break

        sleep(1)

    # wait for the system ready and Supervisor at the latest version
    while True:
        supervisor_info = "\n".join(shell.run_check("ha supervisor info --no-progress --raw-json || true"))
        # make sure not to fail when Supervisor is restarting
        supervisor_info = json.loads(supervisor_info) if supervisor_info.startswith("{") else None
        # make sure not to fail when Supervisor is in setup state
        supervisor_data = supervisor_info.get("data") if supervisor_info else None
        if supervisor_data and supervisor_data["version"] == supervisor_data["version_latest"]:
            output = "\n".join(shell.run_check("ha os info || true"))
            if "System is not ready" not in output:
                break

        sleep(5)


@pytest.mark.dependency(depends=["test_init"])
@pytest.mark.timeout(600)  # TODO: reduce to 300 after 17.0 release
def test_os_update(shell, shell_json, target):
    def check_container_running(container_name):
        out = shell.run_check(
            f"docker container inspect -f '{{{{.State.Status}}}}' {container_name} || true"
        )
        return "running" in out

    # fetch version info and OTA URL
    shell.run_check("ha su reload --no-progress")

    # update OS to latest stable - in tests it should never be the same version
    stable_version = shell_json("curl -sSL https://version.home-assistant.io/stable.json")["hassos"]["ova"]

    # Since Supervisor 2026.07 (home-assistant/supervisor#6982) an OS update no
    # longer reboots automatically: it installs the bundle to the other slot,
    # marks it pending (exposed as "version_pending", see #7006) and raises a
    # reboot-required repair issue. Right after boot the OTA URL might not be
    # available yet, so keep retrying until the update is installed as pending.
    # Once it is, re-requesting the same version is rejected, so we stop then.
    while True:
        shell.run_check(f"ha os update --no-progress --version {stable_version} || true", timeout=300)
        os_info = shell_json("ha os info --no-progress --raw-json")["data"]
        if os_info["version_pending"] == stable_version:
            break
        # OTA info not ready yet (e.g. no URL for OTA updates); refresh and retry
        shell.run_check("ha su reload --no-progress")
        sleep(5)

    # The update is installed but inactive; apply it by rebooting into the new
    # slot (rauc already marked it as the primary boot slot on install).
    shell.console.sendline("ha host reboot --no-progress || true")
    shell.console.expect("Booting `Slot ", timeout=120)

    # reactivate ShellDriver to handle login again
    target.deactivate(shell)
    target.activate(shell)

    # temporary needed for OS 17.0 -> 16.x path, where all containers must be re-downloaded
    while True:
        if check_container_running("hassio_supervisor") and check_container_running("hassio_cli"):
            break

        sleep(1)

    # wait for the system to be ready after update
    while True:
        output = "\n".join(shell.run_check("ha os info || true"))
        if "System is not ready" not in output:
            break

        sleep(1)

    # check the updated version is now running and no update is pending anymore
    os_info = shell_json("ha os info --no-progress --raw-json")["data"]
    assert os_info["version"] == stable_version, "OS did not update successfully"
    assert not os_info["version_pending"], "OS update still pending after reboot"


@pytest.mark.dependency(depends=["test_os_update"])
@pytest.mark.timeout(180)
def test_boot_other_slot(shell, shell_json, target):
    # switch to the other slot
    os_info = shell_json("ha os info --no-progress --raw-json")
    other_version = os_info["data"]["boot_slots"]["A"]["version"]

    # as we sometimes don't get another shell prompt after the boot slot switch,
    # use plain sendline instead of the run_check method
    shell.console.sendline(f"ha os boot-slot other --no-progress || true")

    shell.console.expect("Booting `Slot ", timeout=60)

    # reactivate ShellDriver to handle login again
    target.deactivate(shell)
    target.activate(shell)

    # wait for the system to be ready after switching slots
    while True:
        output = "\n".join(shell.run_check("ha os info || true"))
        if "System is not ready" not in output:
            break

        sleep(1)

    # check that the boot slot has changed
    os_info = shell_json("ha os info --no-progress --raw-json")
    assert os_info["data"]["version"] == other_version
