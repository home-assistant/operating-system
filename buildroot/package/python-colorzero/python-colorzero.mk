################################################################################
#
# python-colorzero
#
################################################################################

PYTHON_COLORZERO_VERSION = 1.1
PYTHON_COLORZERO_SITE = $(call github,waveform80,colorzero,release-$(PYTHON_COLORZERO_VERSION))
PYTHON_COLORZERO_LICENSE = BSD-3-Clause
PYTHON_COLORZERO_LICENSE_FILES = LICENSE.txt
PYTHON_COLORZERO_SETUP_TYPE = setuptools

$(eval $(python-package))
