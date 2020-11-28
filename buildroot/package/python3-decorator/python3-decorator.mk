################################################################################
#
# python3-decorator
#
################################################################################

# Please keep in sync with package/python-decorator/python-decorator.mk
PYTHON3_DECORATOR_VERSION = 4.4.1
PYTHON3_DECORATOR_SITE = https://files.pythonhosted.org/packages/dc/c3/9d378af09f5737cfd524b844cd2fbb0d2263a35c11d712043daab290144d
PYTHON3_DECORATOR_SOURCE = decorator-$(PYTHON3_DECORATOR_VERSION).tar.gz
PYTHON3_DECORATOR_LICENSE = BSD-2-Clause
PYTHON3_DECORATOR_LICENSE_FILES = LICENSE.txt
PYTHON3_DECORATOR_SETUP_TYPE = setuptools
HOST_PYTHON3_DECORATOR_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
