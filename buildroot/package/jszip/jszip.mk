################################################################################
#
# jszip
#
################################################################################

JSZIP_VERSION = 3.2.2
JSZIP_SITE = $(call github,Stuk,jszip,v$(JSZIP_VERSION))
JSZIP_LICENSE = MIT or GPL-3.0
JSZIP_LICENSE_FILES = LICENSE.markdown

define JSZIP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/dist/jszip.min.js \
		$(TARGET_DIR)/var/www/jszip/js/jszip.min.js
endef

$(eval $(generic-package))
