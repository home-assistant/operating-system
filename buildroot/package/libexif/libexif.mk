################################################################################
#
# libexif
#
################################################################################

LIBEXIF_VERSION = 0.6.23
LIBEXIF_SOURCE = libexif-$(LIBEXIF_VERSION).tar.xz
LIBEXIF_SITE = \
	https://github.com/libexif/libexif/releases/download/v$(LIBEXIF_VERSION)
LIBEXIF_INSTALL_STAGING = YES
LIBEXIF_DEPENDENCIES = host-pkgconf
LIBEXIF_LICENSE = LGPL-2.1+
LIBEXIF_LICENSE_FILES = COPYING
LIBEXIF_CPE_ID_VENDOR = libexif_project

$(eval $(autotools-package))
