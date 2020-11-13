################################################################################
#
# python-intelhex
#
################################################################################

PYTHON_INTELHEX_VERSION = 2.3.0
PYTHON_INTELHEX_SOURCE = intelhex-$(PYTHON_INTELHEX_VERSION).tar.gz
PYTHON_INTELHEX_SITE = https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01
PYTHON_INTELHEX_SETUP_TYPE = setuptools
PYTHON_INTELHEX_LICENSE = BSD-3-Clause
PYTHON_INTELHEX_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
