import logging
from time import sleep


_LOGGER = logging.getLogger(__name__)


def test_init(shell):
    def check_container_running(container_name):
        out = shell.run_check(
            f"docker container inspect -f '{{{{.State.Status}}}}' {container_name} || true"
        )
        return "running" in out

    # wait for important containers first
    for _ in range(20):
        if check_container_running("homeassistant") and check_container_running("hassio_supervisor"):
            break

        sleep(5)

    # wait for system ready
    for _ in range(20):
        output = "\n".join(shell.run_check("ha os info || true"))
        if "System is not ready" not in output:
            break

        sleep(5)

    output = shell.run_check("ha os info")
    _LOGGER.info("%s", "\n".join(output))

def test_dmesg(shell):
    output = shell.run_check("dmesg")
    _LOGGER.info("%s", "\n".join(output))


def test_supervisor_logs(shell):
    output = shell.run_check("ha su logs")
    _LOGGER.info("%s", "\n".join(output))


def test_systemctl_status(shell):
    output = shell.run_check(
        "systemctl --no-pager -l status -a || true", timeout=90
    )
    _LOGGER.info("%s", "\n".join(output))
