################################################################################
#
# Bluetooth RTL8723
#
################################################################################

BLUETOOTH_RTL8723_VERSION = 1.0.0
BLUETOOTH_RTL8723_LICENSE = Apache License 2.0
BLUETOOTH_RTL8723_LICENSE_FILES = $(BR2_EXTERNAL_HASSOS_PATH)/../LICENSE
BLUETOOTH_RTL8723_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/bluetooth-rtl8723
BLUETOOTH_RTL8723_SITE_METHOD = local

define BLUETOOTH_RTL8723_BUILD_CMDS
	curl -o $(@D)/rtk_hciattach https://github.com/armbian/build/raw/dee62df8bb2fe8611fd41ddf02063fa15533298c/packages/bsp/rockchip/rtk_hciattach

	curl -o $(@D)/rtl8723b_config.bin https://github.com/armbian/firmware/raw/4723bbb3d1ef70b5fbe7d2599c47d078ab125c47/rtl_bt/rtl8723b_config.bin
	curl -o $(@D)/rtl8723b_fw.bin https://github.com/armbian/firmware/raw/4723bbb3d1ef70b5fbe7d2599c47d078ab125c47/rtl_bt/rtl8723b_fw.bin
endef

define BLUETOOTH_RTL8723_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/hassos-hardware.target.wants
	$(INSTALL) -m 0755 $(@D)/bluetooth-rtl8723 $(TARGET_DIR)/usr/sbin/
	$(INSTALL) -m 0644 $(@D)/bluetooth-rtl8723.service $(TARGET_DIR)/usr/lib/systemd/system/
	ln -fs /usr/lib/systemd/system/bluetooth-rtl8723.service $(TARGET_DIR)/etc/systemd/system/hassos-hardware.target.wants/

	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/rtl_bt
	$(INSTALL) -m 0644 $(@D)/*.bin $(TARGET_DIR)/lib/firmware/rtl_bt/
	$(INSTALL) -m 0755 $(@D)/rtk_hciattach $(TARGET_DIR)/usr/sbin/
endef

$(eval $(generic-package))
