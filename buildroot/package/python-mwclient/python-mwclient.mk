################################################################################
#
# python-mwclient
#
################################################################################

PYTHON_MWCLIENT_VERSION = 0.10.1
PYTHON_MWCLIENT_SOURCE = mwclient-$(PYTHON_MWCLIENT_VERSION).tar.gz
PYTHON_MWCLIENT_SITE = https://files.pythonhosted.org/packages/97/b4/5fc70ad3286a8d8ec4b9ac01acad0f6b00c5a48d4a16b9d3be6519b7eb21
PYTHON_MWCLIENT_LICENSE = MIT
PYTHON_MWCLIENT_LICENSE_FILES = LICENSE.md
PYTHON_MWCLIENT_SETUP_TYPE = setuptools

$(eval $(python-package))
