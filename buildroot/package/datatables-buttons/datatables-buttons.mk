################################################################################
#
# datatables-buttons
#
################################################################################

DATATABLES_BUTTONS_VERSION = 1.6.1
DATATABLES_BUTTONS_SITE = https://datatables.net/releases
DATATABLES_BUTTONS_SOURCE = Buttons-$(DATATABLES_BUTTONS_VERSION).zip
DATATABLES_BUTTONS_LICENSE = MIT
DATATABLES_BUTTONS_LICENSE_FILES = License.txt

define DATATABLES_BUTTONS_EXTRACT_CMDS
	$(UNZIP) $(DATATABLES_BUTTONS_DL_DIR)/$(DATATABLES_BUTTONS_SOURCE) -d $(@D)
	mv $(@D)/Buttons-$(DATATABLES_BUTTONS_VERSION)/* $(@D)
	rmdir $(@D)/Buttons-$(DATATABLES_BUTTONS_VERSION)
endef

define DATATABLES_BUTTONS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/var/www/datatables-buttons/css $(TARGET_DIR)/var/www/datatables-buttons/js
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/var/www/datatables-buttons/css $(@D)/css/*.min.css
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/var/www/datatables-buttons/js $(@D)/js/*.min.js
endef

$(eval $(generic-package))
