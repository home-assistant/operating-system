#############################################################
#
# mingetty
#
#############################################################
MINGETTY_VERSION = 1.08
MINGETTY_SOURCE  = mingetty-$(MINGETTY_VERSION).tar.gz
MINGETTY_SITE    = http://downloads.sourceforge.net/project/mingetty/mingetty/$(MINGETTY_VERSION)

define MINGETTY_BUILD_CMDS
	$(MAKE) CC=$(TARGET_CC) -C $(@D)
endef

define MINGETTY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/mingetty $(TARGET_DIR)/sbin
endef

define MINGETTY_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
