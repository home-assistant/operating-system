################################################################################
#
# gd
#
################################################################################

GD_VERSION = 2.2.5
GD_SOURCE = libgd-$(GD_VERSION).tar.xz
GD_SITE = https://github.com/libgd/libgd/releases/download/gd-$(GD_VERSION)
GD_INSTALL_STAGING = YES
GD_LICENSE = GD license
GD_LICENSE_FILES = COPYING
GD_CONFIG_SCRIPTS = gdlib-config
GD_CONF_OPTS = --without-x --disable-rpath --disable-werror
GD_DEPENDENCIES = host-pkgconf

# 0001-bmp-check-return-value-in-gdImageBmpPtr.patch
GD_IGNORE_CVES += CVE-2018-1000222
# 0002-Fix-420-Potential-infinite-loop-in-gdImageCreateFrom.patch
GD_IGNORE_CVES += CVE-2018-5711
# 0003-Fix-501-Uninitialized-read-in-gdImageCreateFromXbm-C.patch
GD_IGNORE_CVES += CVE-2019-11038
# 0004-Fix-492-Potential-double-free-in-gdImage-Ptr.patch
GD_IGNORE_CVES += CVE-2019-6978
# 0005-Fix-potential-NULL-pointer-dereference-in-gdImageClone.patch
GD_IGNORE_CVES += CVE-2018-14553
# 0006-Fix-497-gdImageColorMatch-Out-Of-Bounds-Write-on-Heap-CVE-2019-6977.patch
GD_IGNORE_CVES += CVE-2019-6977

# gd forgets to link utilities with -pthread even though it uses
# pthreads, causing linking errors with static linking
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
GD_CONF_ENV += LDFLAGS="$(TARGET_LDFLAGS) -pthread"
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
GD_DEPENDENCIES += fontconfig
GD_CONF_OPTS += --with-fontconfig
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
GD_DEPENDENCIES += freetype
GD_CONF_OPTS += --with-freetype=$(STAGING_DIR)/usr
else
GD_CONF_OPTS += --without-freetype
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
GD_DEPENDENCIES += libiconv
# not strictly needed for gd, but ensures -liconv ends up in
# gdlib-config --libs output
GD_CONF_ENV += LIBS="-liconv"
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
GD_DEPENDENCIES += jpeg
GD_CONF_OPTS += --with-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
GD_DEPENDENCIES += libpng
GD_CONF_OPTS += --with-png
else
GD_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_WEBP),y)
GD_DEPENDENCIES += webp
GD_CONF_OPTS += --with-webp
else
GD_CONF_OPTS += --without-webp
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
GD_DEPENDENCIES += tiff
GD_CONF_OPTS += --with-tiff
else
GD_CONF_OPTS += --without-tiff
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXPM),y)
GD_DEPENDENCIES += xlib_libXpm
GD_CONF_OPTS += --with-xpm
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
GD_DEPENDENCIES += zlib
endif

GD_TOOLS_$(BR2_PACKAGE_GD_ANNOTATE)	+= annotate
GD_TOOLS_$(BR2_PACKAGE_GD_BDFTOGD)	+= bdftogd
GD_TOOLS_$(BR2_PACKAGE_GD_GD2COPYPAL)	+= gd2copypal
GD_TOOLS_$(BR2_PACKAGE_GD_GD2TOGIF)	+= gd2togif
GD_TOOLS_$(BR2_PACKAGE_GD_GD2TOPNG)	+= gd2topng
GD_TOOLS_$(BR2_PACKAGE_GD_GDCMPGIF)	+= gdcmpgif
GD_TOOLS_$(BR2_PACKAGE_GD_GDPARTTOPNG)	+= gdparttopng
GD_TOOLS_$(BR2_PACKAGE_GD_GDTOPNG)	+= gdtopng
GD_TOOLS_$(BR2_PACKAGE_GD_GIFTOGD2)	+= giftogd2
GD_TOOLS_$(BR2_PACKAGE_GD_PNGTOGD)	+= pngtogd
GD_TOOLS_$(BR2_PACKAGE_GD_PNGTOGD2)	+= pngtogd2
GD_TOOLS_$(BR2_PACKAGE_GD_WEBPNG)	+= webpng

define GD_REMOVE_TOOLS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,$(GD_TOOLS_))
endef

GD_POST_INSTALL_TARGET_HOOKS += GD_REMOVE_TOOLS

$(eval $(autotools-package))
