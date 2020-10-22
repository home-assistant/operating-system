################################################################################
#
# python-texttable
#
################################################################################

PYTHON_TEXTTABLE_VERSION = 1.6.3
PYTHON_TEXTTABLE_SOURCE = texttable-$(PYTHON_TEXTTABLE_VERSION).tar.gz
PYTHON_TEXTTABLE_SITE = https://files.pythonhosted.org/packages/f5/be/716342325d6d6e05608e3a10e15f192f3723e454a25ce14bc9b9d1332772
PYTHON_TEXTTABLE_SETUP_TYPE = setuptools
PYTHON_TEXTTABLE_LICENSE = MIT
PYTHON_TEXTTABLE_LICENSE_FILES = LICENSE

$(eval $(python-package))
