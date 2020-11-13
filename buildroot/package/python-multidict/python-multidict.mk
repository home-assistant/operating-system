################################################################################
#
# python-multidict
#
################################################################################

PYTHON_MULTIDICT_VERSION = 5.0.0
PYTHON_MULTIDICT_SOURCE = multidict-$(PYTHON_MULTIDICT_VERSION).tar.gz
PYTHON_MULTIDICT_SITE = https://files.pythonhosted.org/packages/d2/5a/e95b0f9ebacd42e094e229a9a0a9e44d02876abf64969d0cb07dadcf3c4a
PYTHON_MULTIDICT_SETUP_TYPE = setuptools
PYTHON_MULTIDICT_LICENSE = Apache-2.0
PYTHON_MULTIDICT_LICENSE_FILES = LICENSE

$(eval $(python-package))
