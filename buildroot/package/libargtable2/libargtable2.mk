################################################################################
#
# libargtable2
#
################################################################################

LIBARGTABLE2_MAJOR_VERSION = 2
LIBARGTABLE2_MINOR_VERSION = 13
LIBARGTABLE2_VERSION = $(LIBARGTABLE2_MAJOR_VERSION).$(LIBARGTABLE2_MINOR_VERSION)
LIBARGTABLE2_SOURCE = argtable2-$(LIBARGTABLE2_MINOR_VERSION).tar.gz
LIBARGTABLE2_SITE = http://downloads.sourceforge.net/project/argtable/argtable/argtable-$(LIBARGTABLE2_VERSION)
LIBARGTABLE2_INSTALL_STAGING = YES
LIBARGTABLE2_CONF_OPTS = \
	--disable-example \
	--disable-kernel-module \
	--enable-lib \
	--enable-util
LIBARGTABLE2_LICENSE = LGPL-2.0+
LIBARGTABLE2_LICENSE_FILES = COPYING

$(eval $(autotools-package))
