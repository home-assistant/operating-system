import os

import pytest


@pytest.hookimpl
def pytest_runtest_setup(item):
    log_dir = item.config.option.lg_log

    if not log_dir:
        return

    logging_plugin = item.config.pluginmanager.get_plugin("logging-plugin")
    logging_plugin.set_log_path(os.path.join(log_dir, f"{item.name}.log"))


@pytest.fixture
def shell_command(target, strategy):
    strategy.transition("shell")
    shell = target.get_driver("ShellDriver")
    return shell
