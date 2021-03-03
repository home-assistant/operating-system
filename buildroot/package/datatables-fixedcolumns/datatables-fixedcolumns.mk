################################################################################
#
# datatables-fixedcolumns
#
################################################################################

DATATABLES_FIXEDCOLUMNS_VERSION = 3.3.0
DATATABLES_FIXEDCOLUMNS_SITE = https://datatables.net/releases
DATATABLES_FIXEDCOLUMNS_SOURCE =  FixedColumns-$(DATATABLES_FIXEDCOLUMNS_VERSION).zip
DATATABLES_FIXEDCOLUMNS_LICENSE = MIT
DATATABLES_FIXEDCOLUMNS_LICENSE_FILES = License.txt

define DATATABLES_FIXEDCOLUMNS_EXTRACT_CMDS
	$(UNZIP) $(DATATABLES_FIXEDCOLUMNS_DL_DIR)/$(DATATABLES_FIXEDCOLUMNS_SOURCE) -d $(@D)
	mv $(@D)/FixedColumns-$(DATATABLES_FIXEDCOLUMNS_VERSION)/* $(@D)
	rmdir $(@D)/FixedColumns-$(DATATABLES_FIXEDCOLUMNS_VERSION)
endef

define DATATABLES_FIXEDCOLUMNS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/var/www/datatables-fixedcolumns/css $(TARGET_DIR)/var/www/datatables-fixedcolumns/js
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/var/www/datatables-fixedcolumns/css $(@D)/css/*.min.css
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/var/www/datatables-fixedcolumns/js $(@D)/js/*.min.js
endef

$(eval $(generic-package))
