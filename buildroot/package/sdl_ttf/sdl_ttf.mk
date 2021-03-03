################################################################################
#
# sdl_ttf
#
################################################################################

# There is unlikely to be a new SDL_ttf release for the foreseeable future:
# https://bugzilla.libsdl.org/show_bug.cgi?id=5344#c1
#
# The unreleased version from HEAD as of 2020-11-09 has several bugfixes
# and DPI scaling support:
# https://hg.libsdl.org/SDL_ttf/rev/7dbd7cd826d6
#
# DPI scaling is used for rendering on HiDPI displays and displays
# with non-square pixels.
SDL_TTF_VERSION = de50cffd41e6
SDL_TTF_SOURCE = $(SDL_TTF_VERSION).tar.gz
SDL_TTF_SITE = https://hg.libsdl.org/SDL_ttf/archive
SDL_TTF_LICENSE = Zlib
SDL_TTF_LICENSE_FILES = COPYING

SDL_TTF_INSTALL_STAGING = YES
SDL_TTF_DEPENDENCIES = sdl freetype
SDL_TTF_CONF_OPTS = \
	--without-x \
	--with-freetype-prefix=$(STAGING_DIR)/usr \
	--with-sdl-prefix=$(STAGING_DIR)/usr

SDL_TTF_MAKE_OPTS = INCLUDES="-I$(STAGING_DIR)/usr/include/SDL"  LDFLAGS="-L$(STAGING_DIR)/usr/lib"
$(eval $(autotools-package))
