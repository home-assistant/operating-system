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

define BLUETOOTH_BCM43XX_BUILD_CMDS
	curl -o $(@D)/BCM43430A1.hcd https://raw.githubusercontent.com/RPi-Distro/bluez-firmware/master/broadcom/BCM43430A1.hcd
	curl -o $(@D)/BCM4345C0.hcd https://raw.githubusercontent.com/RPi-Distro/bluez-firmware/master/broadcom/BCM4345C0.hcd
endef

define BLUETOOTH_BCM43XX_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/systemd/system/hassos-hardware.wants
	cp -f $(@D)/bluetooth-bcm43xx $(TARGET_DIR)/usr/sbin/
	cp -f $(@D)/bluetooth-bcm43xx.service $(TARGET_DIR)/usr/lib/systemd/system/
	ln -fs /usr/lib/systemd/system/bluetooth-bcm43xx.service $(TARGET_DIR)/etc/systemd/system/hassos-hardware.wants/

	mkdir -p $(TARGET_DIR)/lib/firmware/brcm
	cp -f $(@D)/BCM43430A1.hcd $(TARGET_DIR)/lib/firmware/brcm/
	cp -f $(@D)/BCM4345C0.hcd $(TARGET_DIR)/lib/firmware/brcm/
endef

$(eval $(generic-package))
