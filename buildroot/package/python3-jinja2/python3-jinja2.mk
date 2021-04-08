################################################################################
#
# python3-jinja2
#
################################################################################

PYTHON3_JINJA2_VERSION = 2.11.3
PYTHON3_JINJA2_SOURCE = Jinja2-$(PYTHON3_JINJA2_VERSION).tar.gz
PYTHON3_JINJA2_SITE = https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7
PYTHON3_JINJA2_SETUP_TYPE = setuptools
PYTHON3_JINJA2_LICENSE = BSD-3-Clause
PYTHON3_JINJA2_LICENSE_FILES = LICENSE.rst
PYTHON3_JINJA2_CPE_ID_VENDOR = pocoo
PYTHON3_JINJA2_CPE_ID_PRODUCT = jinja2

HOST_PYTHON3_JINJA2_NEEDS_HOST_PYTHON = python3
# In host build, setup.py tries to download markupsafe if it is not installed
HOST_PYTHON3_JINJA2_DEPENDENCIES = host-python3-markupsafe

$(eval $(host-python-package))
