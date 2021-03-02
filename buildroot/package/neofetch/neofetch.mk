################################################################################
#
# neofetch
#
################################################################################

NEOFETCH_VERSION = 7.1.0
NEOFETCH_SITE = $(call github,dylanaraps,neofetch,$(NEOFETCH_VERSION))
NEOFETCH_LICENSE = MIT
NEOFETCH_LICENSE_FILES = LICENSE.md

define NEOFETCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/neofetch \
		$(TARGET_DIR)/usr/bin/neofetch
endef

$(eval $(generic-package))
