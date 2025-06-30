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
@pytest.mark.timeout(300)
def test_os_update(shell, shell_json, target):
    # fetch version info and OTA URL
    shell.run_check("ha su reload --no-progress")

    # update OS to latest stable - in tests it should never be the same version
    stable_version = shell_json("curl -sSL https://version.home-assistant.io/stable.json")["hassos"]["ova"]

    # Core (and maybe Supervisor) might be downloaded at this point, so we need to keep trying
    while True:
        output = "\n".join(shell.run_check(f"ha os update --no-progress --version {stable_version} || true", timeout=120))
        if "Don't have an URL for OTA updates" in output:
            shell.run_check("ha su reload --no-progress")
        elif "Command completed successfully" in output:
            break

        sleep(5)

    shell.console.expect("Booting `Slot ", timeout=60)

    # reactivate ShellDriver to handle login again
    target.deactivate(shell)
    target.activate(shell)

    # wait for the system to be ready after update
    while True:
        output = "\n".join(shell.run_check("ha os info || true"))
        if "System is not ready" not in output:
            break

        sleep(1)

    # check the updated version
    os_info = shell_json("ha os info --no-progress --raw-json")
    assert os_info["data"]["version"] == stable_version, "OS did not update successfully"


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
