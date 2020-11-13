################################################################################
#
# python-spidev
#
################################################################################

PYTHON_SPIDEV_VERSION = 3.5
PYTHON_SPIDEV_SOURCE = spidev-$(PYTHON_SPIDEV_VERSION).tar.gz
PYTHON_SPIDEV_SITE = https://files.pythonhosted.org/packages/62/56/de649e7d95f9fcfaf965a6eb937b4a46bc77ef21487c99cde1a7a0546040
PYTHON_SPIDEV_SETUP_TYPE = setuptools
PYTHON_SPIDEV_LICENSE = MIT
PYTHON_SPIDEV_LICENSE_FILES = README.md

$(eval $(python-package))
