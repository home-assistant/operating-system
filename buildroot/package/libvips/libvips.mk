################################################################################
#
# libvips
#
################################################################################

LIBVIPS_VERSION = 8.8.3
LIBVIPS_SOURCE = vips-$(LIBVIPS_VERSION).tar.gz
LIBVIPS_SITE = https://github.com/libvips/libvips/releases/download/v$(LIBVIPS_VERSION)
LIBVIPS_LICENSE = LGPL-2.1+
LIBVIPS_LICENSE_FILES = COPYING
LIBVIPS_CPE_ID_VENDOR = libvips_project

# Sparc64 compile fails, for all optimization levels except -O0. To
# fix the problem, use -O0 with no optimization instead. Bug reported
# upstream at https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69038.
ifeq ($(BR2_sparc64),y)
LIBVIPS_CXXFLAGS += -O0
endif

LIBVIPS_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) $(LIBVIPS_CXXFLAGS)" \
	LIBS=$(TARGET_NLS_LIBS)

LIBVIPS_CONF_OPTS = \
	--without-dmalloc \
	--without-gsf \
	--without-magick \
	--without-orc \
	--without-lcms \
	--without-OpenEXR \
	--without-openslide \
	--without-matio \
	--without-cfitsio \
	--without-libwebp \
	--without-pangoft2 \
	--without-x \
	--without-zip \
	--without-python
LIBVIPS_INSTALL_STAGING = YES
LIBVIPS_DEPENDENCIES = \
	host-pkgconf expat libglib2 \
	$(TARGET_NLS_DEPENDENCIES)

ifeq ($(BR2_PACKAGE_GIFLIB),y)
LIBVIPS_CONF_OPTS += --with-giflib
LIBVIPS_DEPENDENCIES += giflib
else
LIBVIPS_CONF_OPTS += --without-giflib
endif

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
LIBVIPS_CONF_OPTS += --enable-introspection
LIBVIPS_DEPENDENCIES += gobject-introspection
else
LIBVIPS_CONF_OPTS += --disable-introspection
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBVIPS_CONF_OPTS += --with-jpeg
LIBVIPS_DEPENDENCIES += jpeg
else
LIBVIPS_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LIBVIPS_CONF_OPTS += --with-png
LIBVIPS_DEPENDENCIES += libpng
else
LIBVIPS_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_LIBRSVG),y)
LIBVIPS_CONF_OPTS += --with-rsvg
LIBVIPS_DEPENDENCIES += librsvg
else
LIBVIPS_CONF_OPTS += --without-rsvg
endif

ifeq ($(BR2_PACKAGE_POPPLER),y)
LIBVIPS_CONF_OPTS += --with-poppler
LIBVIPS_DEPENDENCIES += poppler
else
LIBVIPS_CONF_OPTS += --without-poppler
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
LIBVIPS_CONF_OPTS += --with-tiff
LIBVIPS_DEPENDENCIES += tiff
else
LIBVIPS_CONF_OPTS += --without-tiff
endif

ifeq ($(BR2_PACKAGE_FFTW_DOUBLE),y)
LIBVIPS_CONF_OPTS += --with-fftw
LIBVIPS_DEPENDENCIES += fftw-double
else
LIBVIPS_CONF_OPTS += --without-fftw
endif

ifeq ($(BR2_PACKAGE_LIBEXIF),y)
LIBVIPS_CONF_OPTS += --with-libexif
LIBVIPS_DEPENDENCIES += libexif
else
LIBVIPS_CONF_OPTS += --without-libexif
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBVIPS_CONF_OPTS += --with-zlib
LIBVIPS_DEPENDENCIES += zlib
else
LIBVIPS_CONF_OPTS += --without-zlib
endif

$(eval $(autotools-package))
