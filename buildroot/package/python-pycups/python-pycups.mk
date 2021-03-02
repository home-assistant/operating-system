################################################################################
#
# python-pycups
#
################################################################################

PYTHON_PYCUPS_VERSION = 2.0.1
PYTHON_PYCUPS_SOURCE = pycups-$(PYTHON_PYCUPS_VERSION).tar.gz
PYTHON_PYCUPS_SITE = https://files.pythonhosted.org/packages/0c/bb/82546806a86dc16f5eeb76f62ffdc42cce3d43aacd4e25a8b5300eec0263
PYTHON_PYCUPS_SETUP_TYPE = distutils
PYTHON_PYCUPS_LICENSE = GPL-2.0+
PYTHON_PYCUPS_LICENSE_FILES = COPYING
PYTHON_PYCUPS_DEPENDENCIES = cups

$(eval $(python-package))
