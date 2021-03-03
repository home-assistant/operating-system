################################################################################
#
# python-iso8601
#
################################################################################

PYTHON_ISO8601_VERSION = 0.1.13
PYTHON_ISO8601_SOURCE = iso8601-$(PYTHON_ISO8601_VERSION).tar.gz
PYTHON_ISO8601_SITE = https://files.pythonhosted.org/packages/05/90/2d9927dc2d33192f58fe39d2d216313a8380625cd4b062efb93f1afd7a29
PYTHON_ISO8601_SETUP_TYPE = setuptools
PYTHON_ISO8601_LICENSE = MIT
PYTHON_ISO8601_LICENSE_FILES = LICENSE

$(eval $(python-package))
