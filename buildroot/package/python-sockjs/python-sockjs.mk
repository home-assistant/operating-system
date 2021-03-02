################################################################################
#
# python-sockjs
#
################################################################################

PYTHON_SOCKJS_VERSION = 0.11.0
PYTHON_SOCKJS_SOURCE = sockjs-$(PYTHON_SOCKJS_VERSION).tar.gz
PYTHON_SOCKJS_SITE = https://files.pythonhosted.org/packages/88/e9/af7b321f70325fd2af3941aa147efd097156150da635e09efc7ccf70e54d
PYTHON_SOCKJS_SETUP_TYPE = setuptools
PYTHON_SOCKJS_LICENSE = Apache-2.0
PYTHON_SOCKJS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
