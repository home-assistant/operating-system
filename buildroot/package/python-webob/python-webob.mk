################################################################################
#
# python-webob
#
################################################################################

PYTHON_WEBOB_VERSION = 1.8.7
PYTHON_WEBOB_SOURCE = WebOb-$(PYTHON_WEBOB_VERSION).tar.gz
PYTHON_WEBOB_SITE = https://files.pythonhosted.org/packages/c7/45/ee5f034fb4ebe3236fa49e5a4fcbc54444dd22ecf33079cf56f9606d479d
PYTHON_WEBOB_SETUP_TYPE = setuptools
PYTHON_WEBOB_LICENSE = MIT
PYTHON_WEBOB_LICENSE_FILES = docs/license.txt

$(eval $(python-package))
