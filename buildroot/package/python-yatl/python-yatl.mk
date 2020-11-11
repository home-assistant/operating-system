################################################################################
#
# python-yatl
#
################################################################################

PYTHON_YATL_VERSION = 20200430.1
PYTHON_YATL_SOURCE = yatl-$(PYTHON_YATL_VERSION).tar.gz
PYTHON_YATL_SITE = https://files.pythonhosted.org/packages/7f/bd/aa36c1a1d876757e3fa365e6c455097ebd3f2e8e7ded23e75901ff9c9ecf
PYTHON_YATL_SETUP_TYPE = setuptools
PYTHON_YATL_LICENSE = BSD-3-Clause

$(eval $(python-package))
$(eval $(host-python-package))
