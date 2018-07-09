################################################################################
#
# HassOS
#
################################################################################

HASSOS_VERSION = 1.0.0
HASSOS_LICENSE = Apache License 2.0
HASSOS_LICENSE_FILES = $(BR2_EXTERNAL_HASSOS_PATH)/../LICENSE
HASSOS_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/bluetooth-bcm43xx
HASSOS_SITE_METHOD = local

define HASSOS_INSTALL_TARGET_CMDS
	cp -f $(BR2_EXTERNAL_HASSOS_PATH)/package/bluetooth-bcm43xx/bluetooth-bcm43xx.service $(TARGET_DIR)/usr/lib/systemd/system/bluetooth-bcm43xx.service
	ln -fs /usr/lib/systemd/system/bluetooth-bcm43xx.service $(TARGET_DIR)/etc/systemd/system/hassos-hardware.wants/
endef

$(eval $(generic-package))
