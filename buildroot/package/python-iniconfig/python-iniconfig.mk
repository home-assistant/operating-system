################################################################################
#
# python-iniconfig
#
################################################################################

PYTHON_INICONFIG_VERSION = 1.0.1
PYTHON_INICONFIG_SOURCE = iniconfig-$(PYTHON_INICONFIG_VERSION).tar.gz
PYTHON_INICONFIG_SITE = https://files.pythonhosted.org/packages/aa/6e/60dafce419de21f2f3f29319114808cac9f49b6c15117a419737a4ce3813
PYTHON_INICONFIG_SETUP_TYPE = setuptools
PYTHON_INICONFIG_LICENSE = MIT
PYTHON_INICONFIG_LICENSE_FILES = LICENSE

$(eval $(python-package))
