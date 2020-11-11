################################################################################
#
# earlyoom
#
################################################################################

EARLYOOM_VERSION = 1.6
EARLYOOM_SITE = $(call github,rfjakob,earlyoom,v$(EARLYOOM_VERSION))
EARLYOOM_LICENSE = MIT
EARLYOOM_LICENSE_FILES = LICENSE

EARLYOOM_BUILD_TARGETS = earlyoom.service earlyoom
EARLYOOM_INSTALL_TARGETS = install-default install-bin
EARLYOOM_CFLAGS = '$(TARGET_CFLAGS) -std=gnu99 -DVERSION=\"1.6\"'

EARLYOOM_MAKE_OPTS = \
	$(TARGET_CONFIGURE_OPTS) \
	PREFIX=/usr

define EARLYOOM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(EARLYOOM_MAKE_OPTS) -C $(@D) \
		$(EARLYOOM_BUILD_TARGETS) CFLAGS=$(EARLYOOM_CFLAGS)
endef

define EARLYOOM_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(EARLYOOM_MAKE_OPTS) -C $(@D) \
		$(EARLYOOM_INSTALL_TARGETS) DESTDIR=$(TARGET_DIR)
endef

define EARLYOOM_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 $(EARLYOOM_PKGDIR)/S02earlyoom \
		$(TARGET_DIR)/etc/init.d/S02earlyoom
endef

define EARLYOOM_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(@D)/earlyoom.service \
		$(TARGET_DIR)/usr/lib/systemd/system/earlyoom.service
endef

$(eval $(generic-package))
