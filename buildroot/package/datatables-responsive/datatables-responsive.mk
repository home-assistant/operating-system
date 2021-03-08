################################################################################
#
# datatables-responsive
#
################################################################################

DATATABLES_RESPONSIVE_VERSION = 2.2.3
DATATABLES_RESPONSIVE_SITE = https://datatables.net/releases
DATATABLES_RESPONSIVE_SOURCE =  Responsive-$(DATATABLES_RESPONSIVE_VERSION).zip
DATATABLES_RESPONSIVE_LICENSE = MIT
DATATABLES_RESPONSIVE_LICENSE_FILES = License.txt

define DATATABLES_RESPONSIVE_EXTRACT_CMDS
	$(UNZIP) $(DATATABLES_RESPONSIVE_DL_DIR)/$(DATATABLES_RESPONSIVE_SOURCE) -d $(@D)
	mv $(@D)/Responsive-$(DATATABLES_RESPONSIVE_VERSION)/* $(@D)
	rmdir $(@D)/Responsive-$(DATATABLES_RESPONSIVE_VERSION)
endef

define DATATABLES_RESPONSIVE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/var/www/datatables-responsive/css $(TARGET_DIR)/var/www/datatables-responsive/js
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/var/www/datatables-responsive/css $(@D)/css/*.min.css
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/var/www/datatables-responsive/js $(@D)/js/*.min.js
endef

$(eval $(generic-package))
