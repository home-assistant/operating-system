################################################################################
#
# graphicsmagick
#
################################################################################

GRAPHICSMAGICK_VERSION = 1.3.35
GRAPHICSMAGICK_SOURCE = GraphicsMagick-$(GRAPHICSMAGICK_VERSION).tar.xz
GRAPHICSMAGICK_SITE = https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/$(GRAPHICSMAGICK_VERSION)
GRAPHICSMAGICK_LICENSE = MIT
GRAPHICSMAGICK_LICENSE_FILES = Copyright.txt

GRAPHICSMAGICK_INSTALL_STAGING = YES
GRAPHICSMAGICK_CONFIG_SCRIPTS = GraphicsMagick-config GraphicsMagickWand-config

# 0001-MNG-Fix-small-heap-overwrite-or-assertion.patch
GRAPHICSMAGICK_IGNORE_CVES += CVE-2020-12672

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
GRAPHICSMAGICK_CONFIG_SCRIPTS += GraphicsMagick++-config
endif

GRAPHICSMAGICK_CONF_OPTS = \
	--without-dps \
	--without-fpx \
	--without-jbig \
	--without-perl \
	--without-trio \
	--without-wmf \
	--without-x \
	--with-gs-font-dir=/usr/share/fonts/gs

GRAPHICSMAGICK_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_TOOLCHAIN_HAS_OPENMP),y)
GRAPHICSMAGICK_CONF_OPTS += --enable-openmp
else
GRAPHICSMAGICK_CONF_OPTS += --disable-openmp
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
GRAPHICSMAGICK_CONF_OPTS += --with-ttf
GRAPHICSMAGICK_CONF_ENV += ac_cv_path_freetype_config=$(STAGING_DIR)/usr/bin/freetype-config
GRAPHICSMAGICK_DEPENDENCIES += freetype
else
GRAPHICSMAGICK_CONF_OPTS += --without-ttf
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
GRAPHICSMAGICK_CONF_OPTS += --with-jpeg
GRAPHICSMAGICK_DEPENDENCIES += jpeg
else
GRAPHICSMAGICK_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_OPENJPEG),y)
GRAPHICSMAGICK_CONF_OPTS += --with-jp2
GRAPHICSMAGICK_DEPENDENCIES += openjpeg
else
GRAPHICSMAGICK_CONF_OPTS += --without-jp2
endif

ifeq ($(BR2_PACKAGE_LCMS2),y)
GRAPHICSMAGICK_CONF_OPTS += --with-lcms2
GRAPHICSMAGICK_DEPENDENCIES += lcms2
else
GRAPHICSMAGICK_CONF_OPTS += --without-lcms2
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
GRAPHICSMAGICK_CONF_OPTS += --with-png
GRAPHICSMAGICK_DEPENDENCIES += libpng
else
GRAPHICSMAGICK_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
GRAPHICSMAGICK_CONF_OPTS += --with-xml
GRAPHICSMAGICK_CONF_ENV += ac_cv_path_xml2_config=$(STAGING_DIR)/usr/bin/xml2-config
GRAPHICSMAGICK_DEPENDENCIES += libxml2
else
GRAPHICSMAGICK_CONF_OPTS += --without-xml
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
GRAPHICSMAGICK_CONF_OPTS += --with-tiff
GRAPHICSMAGICK_DEPENDENCIES += tiff
else
GRAPHICSMAGICK_CONF_OPTS += --without-tiff
endif

ifeq ($(BR2_PACKAGE_WEBP_MUX),y)
GRAPHICSMAGICK_CONF_OPTS += --with-webp
GRAPHICSMAGICK_DEPENDENCIES += webp
else
GRAPHICSMAGICK_CONF_OPTS += --without-webp
endif

ifeq ($(BR2_PACKAGE_XZ),y)
GRAPHICSMAGICK_CONF_OPTS += --with-lzma
GRAPHICSMAGICK_DEPENDENCIES += xz
else
GRAPHICSMAGICK_CONF_OPTS += --without-lzma
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
GRAPHICSMAGICK_CONF_OPTS += --with-zlib
GRAPHICSMAGICK_DEPENDENCIES += zlib
else
GRAPHICSMAGICK_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
GRAPHICSMAGICK_CONF_OPTS += --with-bzlib
GRAPHICSMAGICK_DEPENDENCIES += bzip2
else
GRAPHICSMAGICK_CONF_OPTS += --without-bzlib
endif

ifeq ($(BR2_PACKAGE_ZSTD),y)
GRAPHICSMAGICK_CONF_OPTS += --with-zstd
GRAPHICSMAGICK_DEPENDENCIES += zstd
else
GRAPHICSMAGICK_CONF_OPTS += --without-zstd
endif

$(eval $(autotools-package))
