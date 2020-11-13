################################################################################
#
# python-aiofiles
#
################################################################################

PYTHON_AIOFILES_VERSION = 0.5.0
PYTHON_AIOFILES_SOURCE = aiofiles-$(PYTHON_AIOFILES_VERSION).tar.gz
PYTHON_AIOFILES_SITE = https://files.pythonhosted.org/packages/2b/64/437053d6a4ba3b3eea1044131a25b458489320cb9609e19ac17261e4dc9b
PYTHON_AIOFILES_SETUP_TYPE = setuptools
PYTHON_AIOFILES_LICENSE = Apache-2.0
PYTHON_AIOFILES_LICENSE_FILES = LICENSE

$(eval $(python-package))
