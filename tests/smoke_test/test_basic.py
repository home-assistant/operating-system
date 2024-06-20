import logging
from time import sleep

import pytest


_LOGGER = logging.getLogger(__name__)


@pytest.mark.dependency()
@pytest.mark.timeout(600)
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


@pytest.mark.dependency(depends=["test_init"])
def test_rauc_status(shell):
    output = shell.run_check("rauc status --output-format=shell")
    # RAUC_BOOT_PRIMARY won't be set if correct grub env is missing
    assert "RAUC_BOOT_PRIMARY='kernel.0'" in output
    assert "rauc-WARNING" not in "\n".join(output)


@pytest.mark.dependency(depends=["test_init"])
def test_dmesg(shell):
    output = shell.run_check("dmesg")
    _LOGGER.info("%s", "\n".join(output))


@pytest.mark.dependency(depends=["test_init"])
def test_supervisor_logs(shell):
    output = shell.run_check("ha su logs")
    _LOGGER.info("%s", "\n".join(output))


@pytest.mark.dependency(depends=["test_init"])
def test_systemctl_status(shell):
    output = shell.run_check("systemctl --no-pager -l status -a || true")
    _LOGGER.info("%s", "\n".join(output))
