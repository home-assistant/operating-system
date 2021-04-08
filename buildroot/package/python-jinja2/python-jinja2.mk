################################################################################
#
# python-jinja2
#
################################################################################

# Please keep in sync with package/python3-jinja2/python3-jinja2.mk
PYTHON_JINJA2_VERSION = 2.11.3
PYTHON_JINJA2_SOURCE = Jinja2-$(PYTHON_JINJA2_VERSION).tar.gz
PYTHON_JINJA2_SITE = https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7
PYTHON_JINJA2_SETUP_TYPE = setuptools
PYTHON_JINJA2_LICENSE = BSD-3-Clause
PYTHON_JINJA2_LICENSE_FILES = LICENSE.rst
PYTHON_JINJA2_CPE_ID_VENDOR = pocoo
PYTHON_JINJA2_CPE_ID_PRODUCT = jinja2

# In host build, setup.py tries to download markupsafe if it is not installed
HOST_PYTHON_JINJA2_DEPENDENCIES = host-python-markupsafe

# Both asyncsupport.py and asyncfilters.py use async feature, that is
# not available in Python 2 and some features available in Python 3.6.
# So in both cases *.py compilation would produce compiler errors.
# Hence remove both files after package extraction.
ifeq ($(BR2_PACKAGE_PYTHON),y)
define PYTHON_JINJA2_REMOVE_ASYNC_SUPPORT
	rm $(@D)/src/jinja2/asyncsupport.py $(@D)/src/jinja2/asyncfilters.py
endef

PYTHON_JINJA2_POST_EXTRACT_HOOKS = PYTHON_JINJA2_REMOVE_ASYNC_SUPPORT
endif

$(eval $(python-package))
$(eval $(host-python-package))
