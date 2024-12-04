################################################################################
#
# Hailo-8 Firmware
#
################################################################################

HAILO8_FIRMWARE_VERSION = 4.19.0
HAILO8_FIRMWARE_LICENSE = PROPRIETARY
HAILO8_FIRMWARE_SOURCE= hailo8_fw.$(HAILO8_FIRMWARE_VERSION).bin
HAILO8_FIRMWARE_SITE="https://hailo-hailort.s3.eu-west-2.amazonaws.com/Hailo8/$(HAILO8_FIRMWARE_VERSION)/FW"

define HAILO8_FIRMWARE_EXTRACT_CMDS
	cp $(HAILO8_FIRMWARE_DL_DIR)/$(HAILO8_FIRMWARE_SOURCE) $(@D)
endef

define HAILO8_FIRMWARE_BUILD_CMDS
	cp $(@D)/$(HAILO8_FIRMWARE_SOURCE) $(@D)/hailo8_fw.bin
endef

define HAILO8_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/hailo
	$(INSTALL) -m 0644 $(@D)/hailo8_fw.bin $(TARGET_DIR)/lib/firmware/hailo/
endef

$(eval $(generic-package))
