################################################################################
#
# python-gpiozero
#
################################################################################

PYTHON_GPIOZERO_VERSION = 1.5.1
PYTHON_GPIOZERO_SITE = $(call github,gpiozero,gpiozero,v$(PYTHON_GPIOZERO_VERSION))
PYTHON_GPIOZERO_LICENSE = BSD-3-Clause
PYTHON_GPIOZERO_LICENSE_FILES = LICENSE.rst
PYTHON_GPIOZERO_SETUP_TYPE = setuptools

$(eval $(python-package))
