################################################################################
#
# python3-cython
#
################################################################################

# Please keep in sync with package/python-cython/python-cython.mk
PYTHON3_CYTHON_VERSION = 0.29.21
PYTHON3_CYTHON_SOURCE = Cython-$(PYTHON3_CYTHON_VERSION).tar.gz
PYTHON3_CYTHON_SITE = https://files.pythonhosted.org/packages/6c/9f/f501ba9d178aeb1f5bf7da1ad5619b207c90ac235d9859961c11829d0160
PYTHON3_CYTHON_SETUP_TYPE = setuptools
PYTHON3_CYTHON_LICENSE = Apache-2.0
PYTHON3_CYTHON_LICENSE_FILES = COPYING.txt LICENSE.txt
HOST_PYTHON3_CYTHON_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
