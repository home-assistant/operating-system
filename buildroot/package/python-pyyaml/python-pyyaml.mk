################################################################################
#
# python-pyyaml
#
################################################################################

# Please keep in sync package/python3-pyyaml/python3-pyyaml.mk
PYTHON_PYYAML_VERSION = 5.4.1
PYTHON_PYYAML_SOURCE = PyYAML-$(PYTHON_PYYAML_VERSION).tar.gz
PYTHON_PYYAML_SITE = https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d
PYTHON_PYYAML_SETUP_TYPE = setuptools
PYTHON_PYYAML_LICENSE = MIT
PYTHON_PYYAML_LICENSE_FILES = LICENSE
PYTHON_PYYAML_CPE_ID_VENDOR = pyyaml
PYTHON_PYYAML_CPE_ID_PRODUCT = pyyaml
PYTHON_PYYAML_DEPENDENCIES = libyaml
HOST_PYTHON_PYYAML_DEPENDENCIES = host-libyaml

$(eval $(python-package))
$(eval $(host-python-package))
