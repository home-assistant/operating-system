import logging
from time import sleep

import pytest


_LOGGER = logging.getLogger(__name__)


@pytest.mark.dependency()
@pytest.mark.timeout(120)
def test_init(shell):
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

    # wait for system ready
    while True:
        output = "\n".join(shell.run_check("ha os info || true"))
        if "System is not ready" not in output:
            break

        sleep(1)

    output = shell.run_check("ha os info")
    _LOGGER.info("%s", "\n".join(output))


def test_rauc_status(shell, shell_json):
    rauc_status = shell.run_check("rauc status --output-format=shell --detailed")
    # RAUC_BOOT_PRIMARY won't be set if correct grub env is missing
    assert "RAUC_BOOT_PRIMARY='kernel.0'" in rauc_status
    assert "rauc-WARNING" not in "\n".join(rauc_status)

    os_info = shell_json("ha os info --no-progress --raw-json")
    expected_version = os_info.get("data", {}).get("version")
    assert expected_version is not None and expected_version != ""

    boot_slots = filter(lambda x: "RAUC_SYSTEM_SLOTS=" in x, rauc_status)
    boot_slots = next(boot_slots, "").replace("RAUC_SYSTEM_SLOTS='", "").replace("'", "")
    assert boot_slots != ""
    booted_idx = boot_slots.split(" ").index("kernel.0")
    assert booted_idx >= 0

    assert f"RAUC_SLOT_STATUS_BUNDLE_VERSION_{booted_idx + 1}='{expected_version}'" in rauc_status


def test_dmesg(shell):
    output = shell.run_check("dmesg")
    _LOGGER.info("%s", "\n".join(output))


@pytest.mark.dependency(depends=["test_init"])
def test_supervisor_logs(shell):
    output = shell.run_check("ha su logs")
    _LOGGER.info("%s", "\n".join(output))


@pytest.mark.dependency(depends=["test_init"])
def test_landing_page(shell):
    web_index = shell.run_check("curl http://localhost:8123")
    assert "</html>" in " ".join(web_index)


def test_systemctl_status(shell):
    output = shell.run_check("systemctl --no-pager -l status -a || true")
    _LOGGER.info("%s", "\n".join(output))


def test_systemctl_check_no_failed(shell):
    output = shell.run_check("systemctl --no-pager -l list-units --state=failed")
    assert "0 loaded units listed." in output, f"Some units failed:\n{"\n".join(output)}"


def test_systemctl_no_cycles(shell):
    # we don't have systemd-analyze available, so check it naively using grep
    output = shell.run_check("journalctl -b0 | grep 'ordering cycle' || true")
    assert not output, f"Found Systemd dependency cycles:\n{"\n".join(output)}"


@pytest.mark.dependency(depends=["test_init"])
def test_custom_swap_size(shell, target):
    output = shell.run_check("stat -c '%s' /mnt/data/swapfile")
    # set new swap size to half of the previous size - round to 4k blocks
    new_swap_size = (int(output[0]) // 2 // 4096) * 4096
    shell.run_check(f"echo 'SWAPSIZE={new_swap_size/1024/1024}M' > /etc/default/haos-swapfile; reboot")
    # reactivate ShellDriver to handle login again
    target.deactivate(shell)
    target.activate(shell)
    output = shell.run_check("stat -c '%s' /mnt/data/swapfile")
    assert int(output[0]) == new_swap_size, f"Incorrect swap size {new_swap_size}B: {output}"


@pytest.mark.dependency(depends=["test_custom_swap_size"])
def test_no_swap(shell, target):
    output = shell.run_check("echo 'SWAPSIZE=0' > /etc/default/haos-swapfile; reboot")
    # reactivate ShellDriver to handle login again
    target.deactivate(shell)
    target.activate(shell)
    output = shell.run_check("systemctl --no-pager -l list-units --state=failed")
    assert "0 loaded units listed." in output, f"Some units failed:\n{"\n".join(output)}"
    swapon = shell.run_check("swapon --show")
    assert swapon == [], f"Swapfile still exists: {swapon}"


def test_kernel_not_tainted(shell):
    """Check if the kernel is not tainted - do it at the end of the
    test suite to increase the chance of catching issues."""
    output = shell.run_check("cat /proc/sys/kernel/tainted")
    assert "\n".join(output) == "0", f"Kernel tainted: {output}"
