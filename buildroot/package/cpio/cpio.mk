################################################################################
#
# cpio
#
################################################################################

CPIO_VERSION = 2.13
CPIO_SOURCE = cpio-$(CPIO_VERSION).tar.bz2
CPIO_SITE = $(BR2_GNU_MIRROR)/cpio
CPIO_CONF_OPTS = --bindir=/bin
CPIO_LICENSE = GPL-3.0+
CPIO_LICENSE_FILES = COPYING
CPIO_CPE_ID_VENDOR = gnu

# 0002-Rewrite-dynamic-string-support.patch
# 0003-Fix-previous-commit.patch
CPIO_IGNORE_CVES += CVE-2021-38185

# cpio uses argp.h which is not provided by uclibc or musl by default.
# Use the argp-standalone package to provide this.
ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
CPIO_DEPENDENCIES += argp-standalone
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
