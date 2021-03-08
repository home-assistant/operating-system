################################################################################
#
# python3-jinja2
#
################################################################################

PYTHON3_JINJA2_VERSION = 2.11.2
PYTHON3_JINJA2_SOURCE = Jinja2-$(PYTHON3_JINJA2_VERSION).tar.gz
PYTHON3_JINJA2_SITE = https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c
PYTHON3_JINJA2_SETUP_TYPE = setuptools
PYTHON3_JINJA2_LICENSE = BSD-3-Clause
PYTHON3_JINJA2_LICENSE_FILES = LICENSE.rst

HOST_PYTHON3_JINJA2_NEEDS_HOST_PYTHON = python3
# In host build, setup.py tries to download markupsafe if it is not installed
HOST_PYTHON3_JINJA2_DEPENDENCIES = host-python3-markupsafe

$(eval $(host-python-package))
