################################################################################
#
# python-aiohttp-jinja2
#
################################################################################

PYTHON_AIOHTTP_JINJA2_VERSION = 1.4.2
PYTHON_AIOHTTP_JINJA2_SOURCE = aiohttp-jinja2-$(PYTHON_AIOHTTP_JINJA2_VERSION).tar.gz
PYTHON_AIOHTTP_JINJA2_SITE = https://files.pythonhosted.org/packages/da/4f/3b1a0c7177fdb0417308a95bfa8340f19cf84b44f8f2d734cd3052f56644
PYTHON_AIOHTTP_JINJA2_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_JINJA2_LICENSE = Apache-2.0
PYTHON_AIOHTTP_JINJA2_LICENSE_FILES = LICENSE

$(eval $(python-package))
