################################################################################
#
# libass
#
################################################################################

LIBASS_VERSION = 0.15.0
LIBASS_SOURCE = libass-$(LIBASS_VERSION).tar.xz
# Do not use the github helper here, the generated tarball is *NOT*
# the same as the one uploaded by upstream for the release.
LIBASS_SITE = https://github.com/libass/libass/releases/download/$(LIBASS_VERSION)
LIBASS_INSTALL_STAGING = YES
LIBASS_LICENSE = ISC
LIBASS_LICENSE_FILES = COPYING
LIBASS_CPE_ID_VENDOR = libass_project
LIBASS_DEPENDENCIES = \
	host-pkgconf \
	freetype \
	harfbuzz \
	libfribidi \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)

# configure: WARNING: Install nasm for a significantly faster libass build.
# only for Intel archs
ifeq ($(BR2_i386)$(BR2_x86_64),y)
LIBASS_DEPENDENCIES += host-nasm
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
LIBASS_DEPENDENCIES += fontconfig
LIBASS_CONF_OPTS += --enable-fontconfig
else
LIBASS_CONF_OPTS += --disable-fontconfig --disable-require-system-font-provider
endif

$(eval $(autotools-package))
