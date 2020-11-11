################################################################################
#
# python-packaging
#
################################################################################

PYTHON_PACKAGING_VERSION = 20.4
PYTHON_PACKAGING_SOURCE = packaging-$(PYTHON_PACKAGING_VERSION).tar.gz
PYTHON_PACKAGING_SITE = https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145
PYTHON_PACKAGING_SETUP_TYPE = setuptools
PYTHON_PACKAGING_LICENSE = Apache-2.0 or BSD-2-Clause
PYTHON_PACKAGING_LICENSE_FILES = LICENSE LICENSE.APACHE LICENSE.BSD

$(eval $(python-package))
