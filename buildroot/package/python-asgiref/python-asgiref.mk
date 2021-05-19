################################################################################
#
# python-asgiref
#
################################################################################

PYTHON_ASGIREF_VERSION = 3.3.4
PYTHON_ASGIREF_SOURCE = asgiref-$(PYTHON_ASGIREF_VERSION).tar.gz
PYTHON_ASGIREF_SITE = https://files.pythonhosted.org/packages/d8/3f/ef696a6d8254f182b1a089aeffb638d2eb83055e603146d3a40605c5b7da
PYTHON_ASGIREF_SETUP_TYPE = setuptools
PYTHON_ASGIREF_LICENSE = BSD-3-Clause
PYTHON_ASGIREF_LICENSE_FILES = LICENSE

$(eval $(python-package))
