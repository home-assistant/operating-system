################################################################################
#
# python-defusedxml
#
################################################################################

PYTHON_DEFUSEDXML_VERSION = 0.6.0
PYTHON_DEFUSEDXML_SOURCE = defusedxml-$(PYTHON_DEFUSEDXML_VERSION).tar.gz
PYTHON_DEFUSEDXML_SITE = https://files.pythonhosted.org/packages/a4/5f/f8aa58ca0cf01cbcee728abc9d88bfeb74e95e6cb4334cfd5bed5673ea77
PYTHON_DEFUSEDXML_SETUP_TYPE = setuptools
PYTHON_DEFUSEDXML_LICENSE = Python-2.0
PYTHON_DEFUSEDXML_LICENSE_FILES = LICENSE

$(eval $(python-package))
