################################################################################
#
# python-crayons
#
################################################################################

PYTHON_CRAYONS_VERSION = 0.4.0
PYTHON_CRAYONS_SOURCE = crayons-$(PYTHON_CRAYONS_VERSION).tar.gz
PYTHON_CRAYONS_SITE = https://files.pythonhosted.org/packages/b8/6b/12a1dea724c82f1c19f410365d3e25356625b48e8009a7c3c9ec4c42488d
PYTHON_CRAYONS_LICENSE = MIT
PYTHON_CRAYONS_LICENSE_FILES = LICENSE
PYTHON_CRAYONS_SETUP_TYPE = setuptools

$(eval $(python-package))
