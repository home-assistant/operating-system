################################################################################
#
# python-wtforms
#
################################################################################

PYTHON_WTFORMS_VERSION = 2.3.3
PYTHON_WTFORMS_SOURCE = WTForms-$(PYTHON_WTFORMS_VERSION).tar.gz
PYTHON_WTFORMS_SITE = https://files.pythonhosted.org/packages/dd/3f/f25d26b1c66896e2876124a12cd8be8f606abf4e1890a20f3ca04e4a1555
PYTHON_WTFORMS_SETUP_TYPE = setuptools
PYTHON_WTFORMS_LICENSE = BSD-3-Clause
PYTHON_WTFORMS_LICENSE_FILES = LICENSE.rst docs/license.rst

$(eval $(python-package))
