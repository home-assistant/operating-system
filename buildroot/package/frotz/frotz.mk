################################################################################
#
# Frotz
#
################################################################################

FROTZ_VERSION = 2.51
FROTZ_SOURCE = frotz-$(FROTZ_VERSION).tar.bz2
FROTZ_SITE = $(call gitlab,DavidGriffith,frotz,$(FROTZ_VERSION))
FROTZ_DEPENDENCIES = host-pkgconf ncurses
FROTZ_LICENSE = GPL-2.0+
FROTZ_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
FROTZ_CURSES=ncursesw
FROTZ_UTF8=yes
else
FROTZ_CURSES=ncurses
endif

define FROTZ_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) PREFIX=/usr CONFIG_DIR=/etc \
		SOUND_TYPE=none CURSES="$(FROTZ_CURSES)" USE_UTF8=$(FROTZ_UTF8) \
		CFLAGS="$(TARGET_CFLAGS) -std=c99"
endef

define FROTZ_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/frotz $(TARGET_DIR)/usr/bin/frotz
endef

$(eval $(generic-package))
