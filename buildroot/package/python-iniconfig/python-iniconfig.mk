################################################################################
#
# python-iniconfig
#
################################################################################

PYTHON_INICONFIG_VERSION = 1.1.1
PYTHON_INICONFIG_SOURCE = iniconfig-$(PYTHON_INICONFIG_VERSION).tar.gz
PYTHON_INICONFIG_SITE = https://files.pythonhosted.org/packages/23/a2/97899f6bd0e873fed3a7e67ae8d3a08b21799430fb4da15cfedf10d6e2c2
PYTHON_INICONFIG_SETUP_TYPE = setuptools
PYTHON_INICONFIG_LICENSE = MIT
PYTHON_INICONFIG_LICENSE_FILES = LICENSE

$(eval $(python-package))
