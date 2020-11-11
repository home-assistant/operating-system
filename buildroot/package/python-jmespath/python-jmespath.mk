################################################################################
#
# python-jmespath
#
################################################################################

PYTHON_JMESPATH_VERSION = 0.9.4
PYTHON_JMESPATH_SOURCE = jmespath-$(PYTHON_JMESPATH_VERSION).tar.gz
PYTHON_JMESPATH_SITE = https://files.pythonhosted.org/packages/2c/30/f0162d3d83e398c7a3b70c91eef61d409dea205fb4dc2b47d335f429de32
PYTHON_JMESPATH_SETUP_TYPE = setuptools
PYTHON_JMESPATH_LICENSE = MIT
PYTHON_JMESPATH_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
