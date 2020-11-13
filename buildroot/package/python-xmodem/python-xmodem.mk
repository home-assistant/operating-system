################################################################################
#
# python-xmodem
#
################################################################################

PYTHON_XMODEM_VERSION = 0.4.6
PYTHON_XMODEM_SOURCE = xmodem-$(PYTHON_XMODEM_VERSION).tar.gz
PYTHON_XMODEM_SITE = https://files.pythonhosted.org/packages/29/5d/a20d7957f207fc4c4c143881ca7b9617ab7700c153012372ef0a934c7710
PYTHON_XMODEM_SETUP_TYPE = setuptools
PYTHON_XMODEM_LICENSE = MIT
PYTHON_XMODEM_LICENSE_FILES = PKG-INFO

$(eval $(python-package))
