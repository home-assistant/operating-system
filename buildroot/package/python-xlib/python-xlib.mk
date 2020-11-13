################################################################################
#
# python-xlib
#
################################################################################

PYTHON_XLIB_VERSION = 0.27
PYTHON_XLIB_SOURCE = python-xlib-$(PYTHON_XLIB_VERSION).tar.bz2
PYTHON_XLIB_SITE = https://files.pythonhosted.org/packages/e8/fa/a61ef33df117de4c57d11b4ba0b624f5352f21aa2e1eda404860155e8855
PYTHON_XLIB_SETUP_TYPE = setuptools
PYTHON_XLIB_LICENSE = LGPL-2.1+
PYTHON_XLIB_LICENSE_FILES = LICENSE
PYTHON_XLIB_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
