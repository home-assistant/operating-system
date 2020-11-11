################################################################################
#
# python-piexif
#
################################################################################

PYTHON_PIEXIF_VERSION = 1.1.3
PYTHON_PIEXIF_SITE = $(call github,hMatoba,Piexif,$(PYTHON_PIEXIF_VERSION))
PYTHON_PIEXIF_LICENSE = MIT
PYTHON_PIEXIF_LICENSE_FILES = LICENSE.txt
PYTHON_PIEXIF_SETUP_TYPE = setuptools

$(eval $(python-package))
