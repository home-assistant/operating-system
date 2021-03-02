################################################################################
#
# python-chardet
#
################################################################################

PYTHON_CHARDET_VERSION = 4.0.0
PYTHON_CHARDET_SOURCE = chardet-$(PYTHON_CHARDET_VERSION).tar.gz
PYTHON_CHARDET_SITE = https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61
PYTHON_CHARDET_SETUP_TYPE = setuptools
PYTHON_CHARDET_LICENSE = LGPL-2.1+
PYTHON_CHARDET_LICENSE_FILES = LICENSE

$(eval $(python-package))
