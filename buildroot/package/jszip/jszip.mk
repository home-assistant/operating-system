################################################################################
#
# jszip
#
################################################################################

JSZIP_VERSION = 3.2.2
JSZIP_SITE = $(call github,Stuk,jszip,v$(JSZIP_VERSION))
JSZIP_LICENSE = MIT or GPL-3.0
JSZIP_LICENSE_FILES = LICENSE.markdown
JSZIP_CPE_ID_VENDOR = jszip_project

# 0001-fix-Use-a-null-prototype-object-for-this-files.patch
JSZIP_IGNORE_CVES += CVE-2021-23413

define JSZIP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/dist/jszip.min.js \
		$(TARGET_DIR)/var/www/jszip/js/jszip.min.js
endef

$(eval $(generic-package))
