################################################################################
#
# parprouted
#
################################################################################

PARPROUTED_VERSION = 0.7
PARPROUTED_SITE = https://www.hazard.maks.net/parprouted
PARPROUTED_LICENSE = GPL-2.0
PARPROUTED_LICENSE_FILES = COPYING

define PARPROUTED_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define PARPROUTED_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/parprouted $(TARGET_DIR)/usr/sbin/parprouted
endef

$(eval $(generic-package))
