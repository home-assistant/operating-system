################################################################################
#
# libraw
#
################################################################################

LIBRAW_VERSION = 0.20.2
LIBRAW_SOURCE = LibRaw-$(LIBRAW_VERSION).tar.gz
LIBRAW_SITE = http://www.libraw.org/data
LIBRAW_INSTALL_STAGING = YES
LIBRAW_CONF_OPTS += \
	--disable-examples \
	--disable-openmp
LIBRAW_LICENSE = LGPL-2.1 or CDDL-1.0
LIBRAW_LICENSE_FILES = LICENSE.LGPL LICENSE.CDDL README.md
LIBRAW_DEPENDENCIES = host-pkgconf
# https://github.com/LibRaw/LibRaw/issues/353
LIBRAW_AUTORECONF = YES
LIBRAW_CXXFLAGS = $(TARGET_CXXFLAGS)
LIBRAW_CONF_ENV = CXXFLAGS="$(LIBRAW_CXXFLAGS)"

ifeq ($(BR2_PACKAGE_JASPER),y)
LIBRAW_CONF_OPTS += --enable-jasper
LIBRAW_DEPENDENCIES += jasper
# glibc prior to 2.18 only defines constants such as SIZE_MAX or
# INT_FAST32_MAX for C++ code if __STDC_LIMIT_MACROS is defined
LIBRAW_CXXFLAGS += -D__STDC_LIMIT_MACROS
else
LIBRAW_CONF_OPTS += --disable-jasper
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBRAW_CONF_OPTS += --enable-jpeg
LIBRAW_DEPENDENCIES += jpeg
else
LIBRAW_CONF_OPTS += --disable-jpeg
endif

ifeq ($(BR2_PACKAGE_LCMS2),y)
LIBRAW_CONF_OPTS += --enable-lcms
LIBRAW_DEPENDENCIES += lcms2 host-pkgconf
else
LIBRAW_CONF_OPTS += --disable-lcms
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBRAW_CONF_OPTS += --enable-zlib
LIBRAW_DEPENDENCIES += zlib
else
LIBRAW_CONF_OPTS += --disable-zlib
endif

$(eval $(autotools-package))
