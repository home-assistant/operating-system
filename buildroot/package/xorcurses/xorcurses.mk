################################################################################
#
# xorcurses
#
################################################################################

XORCURSES_VERSION = 04b664826c5bd30dd483f6a5c8c189ef97e255da
XORCURSES_SITE = $(call github,jwm-art-net,XorCurses,$(XORCURSES_VERSION))
XORCURSES_DEPENDENCIES = ncurses
XORCURSES_LICENSE = GPL-3.0
XORCURSES_LICENSE_FILES = README

define XORCURSES_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -std=gnu99 \
			-DDATADIR='\"/usr/share/xorcurses\"' \
			-DVERSION='\"$(XORCURSES_VERSION)\"'"
endef

define XORCURSES_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/xorcurses $(TARGET_DIR)/usr/bin/xorcurses
	mkdir -p $(TARGET_DIR)/usr/share/xorcurses/maps
	$(INSTALL) -D -m 0644 $(@D)/maps/*.xcm \
		$(TARGET_DIR)/usr/share/xorcurses/maps/
endef

$(eval $(generic-package))
