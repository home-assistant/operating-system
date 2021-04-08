################################################################################
#
# python-py
#
################################################################################

PYTHON_PY_VERSION = 1.10.0
PYTHON_PY_SOURCE = py-$(PYTHON_PY_VERSION).tar.gz
PYTHON_PY_SITE = https://files.pythonhosted.org/packages/0d/8c/50e9f3999419bb7d9639c37e83fa9cdcf0f601a9d407162d6c37ad60be71
PYTHON_PY_DEPENDENCIES = host-python-setuptools-scm
PYTHON_PY_SETUP_TYPE = setuptools
PYTHON_PY_LICENSE = MIT
PYTHON_PY_LICENSE_FILES = LICENSE py/_vendored_packages/iniconfig-1.1.1.dist-info/LICENSE
PYTHON_PY_CPE_ID_VENDOR = pytest
PYTHON_PY_CPE_ID_PRODUCT = py

$(eval $(python-package))
