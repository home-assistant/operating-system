################################################################################
#
# python-janus
#
################################################################################

PYTHON_JANUS_VERSION = 0.5.0
PYTHON_JANUS_SOURCE = janus-$(PYTHON_JANUS_VERSION).tar.gz
PYTHON_JANUS_SITE = https://files.pythonhosted.org/packages/9a/76/fbb89aa5d3cb5f3fec6ce74d34cf980ccd475b015d1a59cb5a14fe4cd2c5
PYTHON_JANUS_SETUP_TYPE = setuptools
PYTHON_JANUS_LICENSE = Apache-2.0
PYTHON_JANUS_LICENSE_FILES = LICENSE

$(eval $(python-package))
