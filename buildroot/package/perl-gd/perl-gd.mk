################################################################################
#
# perl-gd
#
################################################################################

PERL_GD_VERSION = 2.73
PERL_GD_SOURCE = GD-$(PERL_GD_VERSION).tar.gz
PERL_GD_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RU/RURBAN
PERL_GD_DEPENDENCIES = host-perl-extutils-pkgconfig zlib gd
PERL_GD_LICENSE = Artistic or GPL-1.0+
PERL_GD_LICENSE_FILES = LICENSE
PERL_GD_DISTNAME = GD

PERL_GD_CONF_ENV = \
	PATH=$(BR_PATH) \
	PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig"

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
PERL_GD_DEPENDENCIES += fontconfig
PERL_GD_OPTIONS += FONTCONFIG
PERL_GD_CONF_OPTS += -lib_fontconfig_path=$(STAGING_DIR)/usr
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
PERL_GD_DEPENDENCIES += freetype
PERL_GD_OPTIONS += FT
PERL_GD_CONF_OPTS += -lib_ft_path=$(STAGING_DIR)/usr
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
PERL_GD_DEPENDENCIES += jpeg
PERL_GD_OPTIONS += JPEG
PERL_GD_CONF_OPTS += -lib_jpeg_path=$(STAGING_DIR)/usr
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
PERL_GD_DEPENDENCIES += libpng
PERL_GD_OPTIONS += PNG
PERL_GD_CONF_OPTS += -lib_png_path=$(STAGING_DIR)/usr
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXPM),y)
PERL_GD_DEPENDENCIES += xlib_libXpm
PERL_GD_OPTIONS += XPM
PERL_GD_CONF_OPTS += -lib_xpm_path=$(STAGING_DIR)/usr
endif

PERL_GD_CONF_OPTS += \
	-lib_gd_path=$(STAGING_DIR)/usr \
	-lib_zlib_path=$(STAGING_DIR)/usr \
	-options=$(subst $(space),$(comma),$(PERL_GD_OPTIONS))

$(eval $(perl-package))
