################################################################################
#
# python-remi
#
################################################################################

PYTHON_REMI_VERSION = 2020.11.20
PYTHON_REMI_SOURCE = remi-$(PYTHON_REMI_VERSION).tar.gz
PYTHON_REMI_SITE = https://files.pythonhosted.org/packages/47/45/3110334859199be84d9b230fd31e2333b4c69832e15facc0868bed2aa3f3
PYTHON_REMI_LICENSE = Apache-2.0
PYTHON_REMI_SETUP_TYPE = setuptools

$(eval $(python-package))
