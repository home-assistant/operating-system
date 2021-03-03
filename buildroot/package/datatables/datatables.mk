################################################################################
#
# datatables
#
################################################################################

DATATABLES_VERSION = 1.10.20
DATATABLES_SITE = https://datatables.net/releases
DATATABLES_SOURCE =  DataTables-$(DATATABLES_VERSION).zip
DATATABLES_LICENSE = MIT
DATATABLES_LICENSE_FILES = license.txt

define DATATABLES_EXTRACT_CMDS
	$(UNZIP) $(DATATABLES_DL_DIR)/$(DATATABLES_SOURCE) -d $(@D)
	mv $(@D)/DataTables-$(DATATABLES_VERSION)/* $(@D)
	rmdir $(@D)/DataTables-$(DATATABLES_VERSION)
endef

define DATATABLES_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/var/www/datatables/css $(TARGET_DIR)/var/www/datatables/js
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/var/www/datatables/css $(@D)/media/css/*.min.css
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/var/www/datatables/js $(@D)/media/js/*.min.js
endef

$(eval $(generic-package))
