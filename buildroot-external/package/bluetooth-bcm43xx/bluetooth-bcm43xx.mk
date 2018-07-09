################################################################################
#
# Bluetooth BCM43xx
#
################################################################################

BLUETOOTH_BCM43XX_VERSION = 1.0.0
BLUETOOTH_BCM43XX_LICENSE = Apache License 2.0
BLUETOOTH_BCM43XX_LICENSE_FILES = $(BR2_EXTERNAL_HASSOS_PATH)/../LICENSE
BLUETOOTH_BCM43XX_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/bluetooth-bcm43xx
BLUETOOTH_BCM43XX_SITE_METHOD = local

define BLUETOOTH_BCM43XX_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/systemd/system/hassos-hardware.wants
	cp -f $(BR2_EXTERNAL_HASSOS_PATH)/package/bluetooth-bcm43xx/bluetooth-bcm43xx.service $(TARGET_DIR)/usr/lib/systemd/system/bluetooth-bcm43xx.service
	ln -fs /usr/lib/systemd/system/bluetooth-bcm43xx.service $(TARGET_DIR)/etc/systemd/system/hassos-hardware.wants/
endef

$(eval $(generic-package))
