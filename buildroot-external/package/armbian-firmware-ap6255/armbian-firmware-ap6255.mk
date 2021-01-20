################################################################################
#
# armbian-firmware-ap6255
#
################################################################################

ARMBIAN_FIRMWARE_AP6255_VERSION = 292e1e5b5bc5756e9314ea6d494d561422d23264
ARMBIAN_FIRMWARE_AP6255_SITE = https://github.com/armbian/firmware
ARMBIAN_FIRMWARE_AP6255_SITE_METHOD = git

# AP6255 WiFi/BT combo firmware
ifeq ($(BR2_PACKAGE_ARMBIAN_FIRMWARE_AP6255),y)
ARMBIAN_FIRMWARE_AP6255_FILES += \
	BCM4345C0.hcd \
	fw_bcm43455c0_ag.bin \
	fw_bcm43455c0_ag_apsta.bin \
	fw_bcm43455c0_ag_p2p.bin \
	nvram_ap6255.txt \
	brcm/brcmfmac43455-sdio.bin \
	brcm/brcmfmac43455-sdio.clm_blob \
	brcm/brcmfmac43455-sdio.txt \
	brcm/config.txt \

define ARMBIAN_FIRMWARE_AP6255_INSTALL_FILES
	cd $(@D) && \
		$(TAR) cf install.tar $(sort $(ARMBIAN_FIRMWARE_AP6255_FILES)) && \
		$(TAR) xf install.tar -C $(TARGET_DIR)/lib/firmware
endef

ARMBIAN_FIRMWARE_AP6255_LICENSE = PROPRIETARY
ARMBIAN_FIRMWARE_AP6255_REDISTRIBUTE = NO
endif

define ARMBIAN_FIRMWARE_AP6255_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware
	$(ARMBIAN_FIRMWARE_AP6255_INSTALL_FILES)
	$(ARMBIAN_FIRMWARE_AP6255_INSTALL_DIRS)
endef

$(eval $(generic-package))
