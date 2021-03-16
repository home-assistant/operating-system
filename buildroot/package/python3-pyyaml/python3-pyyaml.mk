################################################################################
#
# python3-pyyaml
#
################################################################################

# Please keep in sync with package/python-pyyaml/python-pyyaml.mk
PYTHON3_PYYAML_VERSION = 5.4.1
PYTHON3_PYYAML_SOURCE = PyYAML-$(PYTHON3_PYYAML_VERSION).tar.gz
PYTHON3_PYYAML_SITE = https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d
PYTHON3_PYYAML_SETUP_TYPE = setuptools
PYTHON3_PYYAML_LICENSE = MIT
PYTHON3_PYYAML_LICENSE_FILES = LICENSE
PYTHON3_PYYAML_CPE_ID_VENDOR = pyyaml
PYTHON3_PYYAML_CPE_ID_PRODUCT = pyyaml
HOST_PYTHON3_PYYAML_DL_SUBDIR = python-pyyaml
HOST_PYTHON3_PYYAML_NEEDS_HOST_PYTHON = python3
HOST_PYTHON3_PYYAML_DEPENDENCIES = host-libyaml

$(eval $(host-python-package))
