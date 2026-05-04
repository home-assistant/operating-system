################################################################################
#
# Hailo-10H Firmware
#
################################################################################

HAILO10H_FIRMWARE_VERSION = 5.3.0
HAILO10H_FIRMWARE_LICENSE = PROPRIETARY
HAILO10H_FIRMWARE_REDISTRIBUTE = NO
HAILO10H_FIRMWARE_SOURCE = hailo10h_fw.tar.gz
HAILO10H_FIRMWARE_SITE = https://hailo-hailort.s3.eu-west-2.amazonaws.com/Hailo10H/$(HAILO10H_FIRMWARE_VERSION)/FW

define HAILO10H_FIRMWARE_EXTRACT_CMDS
	mkdir -p $(@D)/firmware
	$(TAR) -xzf $(HAILO10H_FIRMWARE_DL_DIR)/$(HAILO10H_FIRMWARE_SOURCE) -C $(@D)/firmware
endef

define HAILO10H_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/hailo/hailo10h
	$(INSTALL) -m 0644 $(@D)/firmware/* $(TARGET_DIR)/lib/firmware/hailo/hailo10h/
endef

$(eval $(generic-package))
