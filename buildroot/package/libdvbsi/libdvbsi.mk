################################################################################
#
# libdvbsi
#
################################################################################

LIBDVBSI_VERSION = 0.3.9
LIBDVBSI_SOURCE = libdvbsi++-$(LIBDVBSI_VERSION).tar.bz2
LIBDVBSI_SITE = https://github.com/mtdcr/libdvbsi/releases/download/$(LIBDVBSI_VERSION)
LIBDVBSI_INSTALL_STAGING = YES
LIBDVBSI_LICENSE = LGPL-2.1
LIBDVBSI_LICENSE_FILES = COPYING

$(eval $(autotools-package))
