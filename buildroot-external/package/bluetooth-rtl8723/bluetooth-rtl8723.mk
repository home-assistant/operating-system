################################################################################
#
# Bluetooth RTL8723
#
################################################################################

BLUETOOTH_RTL8723_VERSION = 1.1.0
BLUETOOTH_RTL8723_LICENSE = Apache License 2.0
BLUETOOTH_RTL8723_LICENSE_FILES = $(BR2_EXTERNAL_HASSOS_PATH)/../LICENSE
BLUETOOTH_RTL8723_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/bluetooth-rtl8723
BLUETOOTH_RTL8723_SITE_METHOD = local

define BLUETOOTH_RTL8723_BUILD_CMDS
	curl -L -o $(@D)/rtl8723bs_config.bin https://raw.githubusercontent.com/home-assistant/hassos-blobs/e0c8b7aebb626694cf5c017a9e03068aee2bc604/rtl_bt/rtl8723b_config.bin
endef

define BLUETOOTH_RTL8723_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/rtlbt
	$(INSTALL) -m 0644 $(@D)/rtl8723bs_config.bin $(TARGET_DIR)/lib/firmware/rtl_bt/
endef

$(eval $(generic-package))
