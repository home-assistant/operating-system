import logging
from time import sleep

import pytest
from labgrid.driver import ExecutionError


logger = logging.getLogger(__name__)


@pytest.fixture(scope="module")
def stash() -> dict:
    """Simple stash for sharing data between tests in this module."""
    stash = {}
    return stash


@pytest.mark.dependency()
@pytest.mark.timeout(600)
def test_start_supervisor(shell, shell_json):
    def check_container_running(container_name):
        out = shell.run_check(f"docker container inspect -f '{{{{.State.Status}}}}' {container_name} || true")
        return "running" in out

    while True:
        if check_container_running("homeassistant") and check_container_running("hassio_supervisor"):
            break

        sleep(1)

    supervisor_ip = "\n".join(
        shell.run_check("docker inspect --format='{{.NetworkSettings.IPAddress}}' hassio_supervisor")
    )

    while True:
        try:
            if shell_json(f"curl -sSL http://{supervisor_ip}/supervisor/ping").get("result") == "ok":
                break
        except ExecutionError:
            pass  # avoid failure when the container is restarting

        sleep(1)


@pytest.mark.dependency(depends=["test_start_supervisor"])
def test_check_supervisor(shell_json):
    # check supervisor info
    supervisor_info = shell_json("ha supervisor info --no-progress --raw-json")
    assert supervisor_info.get("result") == "ok", "supervisor info failed"
    logger.info("Supervisor info: %s", supervisor_info)
    # check network info
    network_info = shell_json("ha network info --no-progress --raw-json")
    assert network_info.get("result") == "ok", "network info failed"
    logger.info("Network info: %s", network_info)


@pytest.mark.dependency(depends=["test_check_supervisor"])
@pytest.mark.timeout(300)
def test_update_supervisor(shell_json):
    supervisor_info = shell_json("ha supervisor info --no-progress --raw-json")
    supervisor_version = supervisor_info.get("data").get("version")
    if supervisor_version == supervisor_info.get("data").get("version_latest"):
        logger.info("Supervisor is already up to date")
        pytest.skip("Supervisor is already up to date")
    else:
        result = shell_json("ha supervisor update --no-progress --raw-json")
        if result.get("result") == "error" and "Another job is running" in result.get("message"):
            pass
        else:
            assert result.get("result") == "ok", f"Supervisor update failed: {result}"

        while True:
            try:
                supervisor_info = shell_json("ha supervisor info --no-progress --raw-json")
                data = supervisor_info.get("data")
                if data and data.get("version") == data.get("version_latest"):
                    logger.info(
                        "Supervisor updated from %s to %s: %s",
                        supervisor_version,
                        data.get("version"),
                        supervisor_info,
                    )
                    break
            except ExecutionError:
                pass  # avoid failure when the container is restarting

            sleep(1)


@pytest.mark.dependency(depends=["test_check_supervisor"])
def test_supervisor_is_updated(shell_json):
    supervisor_info = shell_json("ha supervisor info --no-progress --raw-json")
    data = supervisor_info.get("data")
    assert data and data.get("version") == data.get("version_latest")


@pytest.mark.dependency(depends=["test_supervisor_is_updated"])
def test_addon_install(shell_json):
    # install Core SSH add-on
    assert (
        shell_json("ha addons install core_ssh --no-progress --raw-json").get("result") == "ok"
    ), "Core SSH add-on install failed"
    # check Core SSH add-on is installed
    assert (
        shell_json("ha addons info core_ssh --no-progress --raw-json").get("data", {}).get("version") is not None
    ), "Core SSH add-on not installed"
    # start Core SSH add-on
    assert (
        shell_json("ha addons start core_ssh --no-progress --raw-json").get("result") == "ok"
    ), "Core SSH add-on start failed"
    # check Core SSH add-on is running
    ssh_info = shell_json("ha addons info core_ssh --no-progress --raw-json")
    assert ssh_info.get("data", {}).get("state") == "started", "Core SSH add-on not running"
    logger.info("Core SSH add-on info: %s", ssh_info)


@pytest.mark.dependency(depends=["test_supervisor_is_updated"])
def test_code_sign(shell_json):
    # enable Content-Trust
    assert (
        shell_json("ha security options --content-trust=true --no-progress --raw-json").get("result") == "ok"
    ), "Content-Trust enable failed"
    # run Supervisor health check
    health_check = shell_json("ha resolution healthcheck --no-progress --raw-json")
    assert health_check.get("result") == "ok", "Supervisor health check failed"
    logger.info("Supervisor health check result: %s", health_check)
    # get resolution center info
    resolution_info = shell_json("ha resolution info --no-progress --raw-json")
    logger.info("Resolution center info: %s", resolution_info)
    # check supervisor is healthy
    unhealthy = resolution_info.get("data").get("unhealthy")
    assert len(unhealthy) == 0, "Supervisor is unhealthy"
    # check for unsupported entries
    unsupported = resolution_info.get("data").get("unsupported")
    assert len(unsupported) == 0, "Unsupported entries found"


@pytest.mark.dependency(depends=["test_supervisor_is_updated"])
def test_create_backup(shell_json, stash):
    result = shell_json("ha backups new --no-progress --raw-json")
    assert result.get("result") == "ok", f"Backup creation failed: {result}"
    slug = result.get("data", {}).get("slug")
    assert slug is not None
    stash.update(slug=slug)
    logger.info("Backup creation result: %s", result)


@pytest.mark.dependency(depends=["test_addon_install"])
def test_addon_uninstall(shell_json):
    result = shell_json("ha addons uninstall core_ssh --no-progress --raw-json")
    assert result.get("result") == "ok", f"Core SSH add-on uninstall failed: {result}"
    logger.info("Core SSH add-on uninstall result: %s", result)


@pytest.mark.dependency(depends=["test_supervisor_is_updated"])
@pytest.mark.timeout(450)
def test_restart_supervisor(shell, shell_json):
    result = shell_json("ha supervisor restart --no-progress --raw-json")
    assert result.get("result") == "ok", f"Supervisor restart failed: {result}"

    supervisor_ip = "\n".join(
        shell.run_check("docker inspect --format='{{.NetworkSettings.IPAddress}}' hassio_supervisor")
    )

    while True:
        try:
            if shell_json(f"curl -sSL http://{supervisor_ip}/supervisor/ping").get("result") == "ok":
                if shell_json("ha os info --no-progress --raw-json").get("result") == "ok":
                    break
        except ExecutionError:
            pass  # avoid failure when the container is restarting

        sleep(1)


@pytest.mark.dependency(depends=["test_create_backup"])
def test_restore_backup(shell_json, stash):
    result = shell_json(f"ha backups restore {stash.get('slug')} --addons core_ssh --no-progress --raw-json")
    assert result.get("result") == "ok", f"Backup restore failed: {result}"
    logger.info("Backup restore result: %s", result)

    addon_info = shell_json("ha addons info core_ssh --no-progress --raw-json")
    assert addon_info.get("data", {}).get("version") is not None, "Core SSH add-on not installed"
    assert addon_info.get("data", {}).get("state") == "started", "Core SSH add-on not running"
    logger.info("Core SSH add-on info: %s", addon_info)


@pytest.mark.dependency(depends=["test_create_backup"])
def test_restore_ssl_directory(shell_json, stash):
    result = shell_json(f"ha backups restore {stash.get('slug')} --folders ssl --no-progress --raw-json")
    assert result.get("result") == "ok", f"Backup restore failed: {result}"
    logger.info("Backup restore result: %s", result)
