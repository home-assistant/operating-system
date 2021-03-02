################################################################################
#
# python-jmespath
#
################################################################################

PYTHON_JMESPATH_VERSION = 0.10.0
PYTHON_JMESPATH_SOURCE = jmespath-$(PYTHON_JMESPATH_VERSION).tar.gz
PYTHON_JMESPATH_SITE = https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8
PYTHON_JMESPATH_SETUP_TYPE = setuptools
PYTHON_JMESPATH_LICENSE = MIT
PYTHON_JMESPATH_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
