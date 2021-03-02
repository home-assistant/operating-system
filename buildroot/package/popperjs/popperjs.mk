################################################################################
#
# popperjs
#
################################################################################

POPPERJS_VERSION = 1.16.0
POPPERJS_SITE = $(call github,popperjs,popper-core,v$(POPPERJS_VERSION))
POPPERJS_LICENSE = MIT
POPPERJS_LICENSE_FILES = LICENSE.md

define POPPERJS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/dist/umd/popper.min.js \
		$(TARGET_DIR)/var/www/popperjs/js/popper.min.js
	$(INSTALL) -m 0644 -D $(@D)/dist/umd/popper-utils.min.js \
		$(TARGET_DIR)/var/www/popperjs/js/popper-utils.min.js
endef

$(eval $(generic-package))
