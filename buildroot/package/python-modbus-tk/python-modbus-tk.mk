################################################################################
#
# python-modbus-tk
#
################################################################################

PYTHON_MODBUS_TK_VERSION = 1.1.1
PYTHON_MODBUS_TK_SOURCE = modbus_tk-$(PYTHON_MODBUS_TK_VERSION).tar.gz
PYTHON_MODBUS_TK_SITE = https://files.pythonhosted.org/packages/63/2e/991c8965fd45db4c38fefe1fa70356825e847e1bbb1f14e127aa2b4d37aa
PYTHON_MODBUS_TK_SETUP_TYPE = setuptools
PYTHON_MODBUS_TK_LICENSE = LGPL-2.1+
PYTHON_MODBUS_TK_LICENSE_FILES = license.txt copying.txt

$(eval $(python-package))
