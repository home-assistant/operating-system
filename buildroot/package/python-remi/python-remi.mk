################################################################################
#
# python-remi
#
################################################################################

PYTHON_REMI_VERSION = 2020.8.6
PYTHON_REMI_SOURCE = remi-$(PYTHON_REMI_VERSION).tar.gz
PYTHON_REMI_SITE = https://files.pythonhosted.org/packages/d1/74/e2a1f5df4e57170369b221017c954ce9002901b9cc136365de0cf300e72a
PYTHON_REMI_LICENSE = Apache-2.0
PYTHON_REMI_SETUP_TYPE = setuptools

$(eval $(python-package))
