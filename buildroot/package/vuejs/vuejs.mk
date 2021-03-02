################################################################################
#
# vuejs
#
################################################################################

VUEJS_VERSION = 3.0.5
VUEJS_SOURCE = vue-$(VUEJS_VERSION).tgz
VUEJS_SITE = https://registry.npmjs.org/vue/-
VUEJS_LICENSE = MIT

# Install .min.js as .js
define VUEJS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 644 -D $(@D)/dist/vue.global.prod.js \
		$(TARGET_DIR)/var/www/vue.js
endef

$(eval $(generic-package))
