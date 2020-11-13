################################################################################
#
# lua-gd
#
################################################################################

LUA_GD_VERSION = 2ce8e478a8591afd71e607506bc8c64b161bbd30
LUA_GD_SITE = $(call github,ittner,lua-gd,$(LUA_GD_VERSION))
LUA_GD_LICENSE = MIT
LUA_GD_LICENSE_FILES = COPYING
LUA_GD_DEPENDENCIES = luainterpreter gd

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
LUA_GD_FEATURES += -DGD_FONTCONFIG
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
LUA_GD_FEATURES += -DGD_FREETYPE
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LUA_GD_FEATURES += -DGD_JPEG
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LUA_GD_FEATURES += -DGD_PNG
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXPM),y)
LUA_GD_FEATURES += -DGD_XPM
endif

# VERSION follows the scheme described on https://ittner.github.io/lua-gd/manual.html#intro,
# the current version of the binding is 3.
define LUA_GD_BUILD_CMDS
	$(MAKE) -C $(@D) gd.so \
		GDFEATURES="$(LUA_GD_FEATURES)" \
		CC=$(TARGET_CC) \
		CFLAGS="$(TARGET_CFLAGS) -fPIC -DVERSION=\\\"$(GD_VERSION)r3\\\"" \
		LFLAGS="-shared -lgd"
endef

define LUA_GD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/gd.so $(TARGET_DIR)/usr/lib/lua/$(LUAINTERPRETER_ABIVER)/gd.so
endef

$(eval $(generic-package))
