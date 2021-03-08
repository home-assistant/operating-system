################################################################################
#
# python-yatl
#
################################################################################

PYTHON_YATL_VERSION = 20200711.1
PYTHON_YATL_SOURCE = yatl-$(PYTHON_YATL_VERSION).tar.gz
PYTHON_YATL_SITE = https://files.pythonhosted.org/packages/b4/f5/b6020f8ccb3e156fbe0ed7e4a35fbdce4d6a7ef6a9ab0c54cb8880fb7c04
PYTHON_YATL_SETUP_TYPE = setuptools
PYTHON_YATL_LICENSE = BSD-3-Clause

$(eval $(python-package))
$(eval $(host-python-package))
