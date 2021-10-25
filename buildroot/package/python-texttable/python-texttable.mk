################################################################################
#
# python-texttable
#
################################################################################

PYTHON_TEXTTABLE_VERSION = 1.6.4
PYTHON_TEXTTABLE_SOURCE = texttable-$(PYTHON_TEXTTABLE_VERSION).tar.gz
PYTHON_TEXTTABLE_SITE = https://files.pythonhosted.org/packages/d5/78/dbc2a5eab57a01fedaf975f2c16f04e76f09336dbeadb9994258aa0a2b1a
PYTHON_TEXTTABLE_SETUP_TYPE = setuptools
PYTHON_TEXTTABLE_LICENSE = MIT
PYTHON_TEXTTABLE_LICENSE_FILES = LICENSE

$(eval $(python-package))
