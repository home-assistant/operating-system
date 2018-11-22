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
	curl -L -o $(@D)/BCM43430A1.hcd https://raw.githubusercontent.com/RPi-Distro/bluez-firmware/ade2bae1aaaebede09abb8fb546f767a0e4c7804/broadcom/BCM43430A1.hcd
	curl -L -o $(@D)/BCM4345C0.hcd https://raw.githubusercontent.com/RPi-Distro/bluez-firmware/ade2bae1aaaebede09abb8fb546f767a0e4c7804/broadcom/BCM4345C0.hcd
endef

define BLUETOOTH_BCM43XX_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/hassos-hardware.target.wants
	$(INSTALL) -m 0755 $(@D)/bluetooth-bcm43xx $(TARGET_DIR)/usr/sbin/
	$(INSTALL) -m 0644 $(@D)/bluetooth-bcm43xx.service $(TARGET_DIR)/usr/lib/systemd/system/
	ln -fs /usr/lib/systemd/system/bluetooth-bcm43xx.service $(TARGET_DIR)/etc/systemd/system/hassos-hardware.target.wants/

	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/brcm
	$(INSTALL) -m 0644 $(@D)/*.hcd $(TARGET_DIR)/lib/firmware/brcm/

	$(INSTALL) -d $(TARGET_DIR)/usr/lib/udev/rules.d
	$(INSTALL) -m 0644 $(@D)/bluetooth-bcm43xx.rules $(TARGET_DIR)/usr/lib/udev/rules.d/
endef

$(eval $(generic-package))
