################################################################################
#
# python-cbor2
#
################################################################################

PYTHON_CBOR2_VERSION = 5.1.2
PYTHON_CBOR2_SOURCE = cbor2-$(PYTHON_CBOR2_VERSION).tar.gz
PYTHON_CBOR2_SITE = https://files.pythonhosted.org/packages/3f/14/a7cdcab562ee9b599ce409168eb0a5f7c7190a83f23c92c8c310e56d1b58
PYTHON_CBOR2_SETUP_TYPE = setuptools
PYTHON_CBOR2_LICENSE = MIT
PYTHON_CBOR2_LICENSE_FILES = LICENSE.txt
PYTHON_CBOR2_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
