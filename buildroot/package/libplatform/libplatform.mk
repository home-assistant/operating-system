################################################################################
#
# libplatform
#
################################################################################

LIBPLATFORM_VERSION = 1c9d14fa996af33760a2c700caebd2bd9ae527c9
LIBPLATFORM_SITE = $(call github,Pulse-Eight,platform,$(LIBPLATFORM_VERSION))
LIBPLATFORM_LICENSE = GPL-2.0+
LIBPLATFORM_LICENSE_FILES = src/os.h
LIBPLATFORM_INSTALL_STAGING = YES

$(eval $(cmake-package))
