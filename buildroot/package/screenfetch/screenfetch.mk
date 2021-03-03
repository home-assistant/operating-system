################################################################################
#
# screenfetch
#
################################################################################

SCREENFETCH_VERSION = 3.9.1
SCREENFETCH_SITE = $(call github,KittyKatt,screenFetch,v$(SCREENFETCH_VERSION))
SCREENFETCH_LICENSE = GPL-3.0+
SCREENFETCH_LICENSE_FILES = COPYING

define SCREENFETCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/screenfetch-dev \
		$(TARGET_DIR)/usr/bin/screenfetch
endef

$(eval $(generic-package))
