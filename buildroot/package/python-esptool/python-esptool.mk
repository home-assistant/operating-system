################################################################################
#
# python-esptool
#
################################################################################

PYTHON_ESPTOOL_VERSION = 3.0
PYTHON_ESPTOOL_SOURCE = esptool-$(PYTHON_ESPTOOL_VERSION).tar.gz
PYTHON_ESPTOOL_SITE = https://files.pythonhosted.org/packages/dd/3d/d1d4c004927e6e6807c441ce70330ed969c725d2906053fbd2ff994b4439
PYTHON_ESPTOOL_SETUP_TYPE = setuptools
PYTHON_ESPTOOL_LICENSE = GPL-2.0+
PYTHON_ESPTOOL_LICENSE_FILES = LICENSE

$(eval $(python-package))
