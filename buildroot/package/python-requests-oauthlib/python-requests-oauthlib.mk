################################################################################
#
# python-requests-oauthlib
#
################################################################################

PYTHON_REQUESTS_OAUTHLIB_VERSION = 1.3.0
PYTHON_REQUESTS_OAUTHLIB_SOURCE = requests-oauthlib-$(PYTHON_REQUESTS_OAUTHLIB_VERSION).tar.gz
PYTHON_REQUESTS_OAUTHLIB_SITE = https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f
PYTHON_REQUESTS_OAUTHLIB_SETUP_TYPE = setuptools
PYTHON_REQUESTS_OAUTHLIB_LICENSE = ISC
PYTHON_REQUESTS_OAUTHLIB_LICENSE_FILES = LICENSE

$(eval $(python-package))
