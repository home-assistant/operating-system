################################################################################
#
# python-pytest
#
################################################################################

PYTHON_PYTEST_VERSION = 6.1.2
PYTHON_PYTEST_SOURCE = pytest-$(PYTHON_PYTEST_VERSION).tar.gz
PYTHON_PYTEST_SITE = https://files.pythonhosted.org/packages/d4/df/bd7c25c4fe809a17315b3fc9878edf48d31dde7b431b6836848b063c0428
PYTHON_PYTEST_SETUP_TYPE = setuptools
PYTHON_PYTEST_LICENSE = MIT
PYTHON_PYTEST_LICENSE_FILES = LICENSE
PYTHON_PYTEST_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
