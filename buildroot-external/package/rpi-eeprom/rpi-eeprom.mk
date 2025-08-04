################################################################################
#
# rpi-eeprom
#
################################################################################

RPI_EEPROM_VERSION = 2349daafacfb7a7abe2cfecf30a49ae837bdf2c6
RPI_EEPROM_SITE = $(call github,raspberrypi,rpi-eeprom,$(RPI_EEPROM_VERSION))
RPI_EEPROM_LICENSE = BSD-3-Clause
RPI_EEPROM_LICENSE_FILES = LICENSE

ifneq ($(BR2_PACKAGE_RPI_EEPROM_TARGET_ANY)$(BR2_PACKAGE_RPI_EEPROM_TARGET_RPI4),)
define RPI_EEPROM_INSTALL_RPI4_FILES
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/firmware/raspberrypi/bootloader-2711/default
	$(INSTALL) -D -m 0644 $(@D)/firmware-2711/default/recovery.bin $(TARGET_DIR)/usr/lib/firmware/raspberrypi/bootloader-2711/default/
	$(INSTALL) -D -m 0644 $(@D)/firmware-2711/default/vl805-000138c0.bin $(TARGET_DIR)/usr/lib/firmware/raspberrypi/bootloader-2711/default/
	$(INSTALL) -D -m 0644 $(@D)/firmware-2711/default/pieeprom-2025-05-08.bin $(TARGET_DIR)/usr/lib/firmware/raspberrypi/bootloader-2711/default/
endef
endif

ifneq ($(BR2_PACKAGE_RPI_EEPROM_TARGET_ANY)$(BR2_PACKAGE_RPI_EEPROM_TARGET_RPI5),)
define RPI_EEPROM_INSTALL_RPI5_FILES
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/firmware/raspberrypi/bootloader-2712/default
	$(INSTALL) -D -m 0644 $(@D)/firmware-2712/default/recovery.bin $(TARGET_DIR)/usr/lib/firmware/raspberrypi/bootloader-2712/default/
	$(INSTALL) -D -m 0644 $(@D)/firmware-2712/default/pieeprom-2025-05-08.bin $(TARGET_DIR)/usr/lib/firmware/raspberrypi/bootloader-2712/default/
endef
endif

define RPI_EEPROM_INSTALL_TARGET_CMDS
	$(RPI_EEPROM_INSTALL_RPI4_FILES)
	$(RPI_EEPROM_INSTALL_RPI5_FILES)
	$(INSTALL) -D -m 0755 $(@D)/rpi-eeprom-config $(TARGET_DIR)/usr/bin/rpi-eeprom-config
	$(INSTALL) -D -m 0755 $(@D)/rpi-eeprom-digest $(TARGET_DIR)/usr/bin/rpi-eeprom-digest
	$(INSTALL) -D -m 0755 $(@D)/rpi-eeprom-update $(TARGET_DIR)/usr/bin/rpi-eeprom-update
endef

$(eval $(generic-package))
