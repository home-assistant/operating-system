################################################################################
#
# python-sh
#
################################################################################

PYTHON_SH_VERSION = 1.13.1
PYTHON_SH_SOURCE = sh-$(PYTHON_SH_VERSION).tar.gz
PYTHON_SH_SITE = https://files.pythonhosted.org/packages/c9/3b/2c9a22bf1c48ced7ff3a11d4a862682c21d825c35f9d025811ad9808d263
PYTHON_SH_SETUP_TYPE = setuptools
PYTHON_SH_LICENSE = MIT
PYTHON_SH_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
