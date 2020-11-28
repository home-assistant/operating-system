################################################################################
#
# libexif
#
################################################################################

LIBEXIF_VERSION = 0.6.22
LIBEXIF_SOURCE = libexif-$(LIBEXIF_VERSION).tar.xz
LIBEXIF_SITE = \
	https://github.com/libexif/libexif/releases/download/libexif-$(subst .,_,$(LIBEXIF_VERSION))-release
LIBEXIF_INSTALL_STAGING = YES
LIBEXIF_DEPENDENCIES = host-pkgconf
LIBEXIF_LICENSE = LGPL-2.1+
LIBEXIF_LICENSE_FILES = COPYING
# 0001-fixed-another-unsigned-integer-overflow.patch
LIBEXIF_IGNORE_CVES += CVE-2020-0198
# 0002-fixed-a-incorrect-overflow-check.patch
LIBEXIF_IGNORE_CVES += CVE-2020-0452

$(eval $(autotools-package))
