################################################################################
#
# qcom-db410c-firmware
#
################################################################################

QCOM_DB410C_FIRMWARE_VERSION = 1034.2.1
QCOM_DB410C_FIRMWARE_BASE = linux-board-support-package-r$(QCOM_DB410C_FIRMWARE_VERSION)
QCOM_DB410C_FIRMWARE_SOURCE = $(QCOM_DB410C_FIRMWARE_BASE).zip
QCOM_DB410C_FIRMWARE_SITE = https://releases.linaro.org/96boards/dragonboard410c/qualcomm/firmware
QCOM_DB410C_FIRMWARE_LICENCE = Qualcomm firmware license
QCOM_DB410C_FIRMWARE_LICENSE_FILES = LICENSE
QCOM_DB410C_FIRMWARE_DEPENDENCIES = host-mtools

define QCOM_DB410C_FIRMWARE_EXTRACT_CMDS
	$(UNZIP) -d $(@D) \
		$(QCOM_DB410C_FIRMWARE_DL_DIR)/$(QCOM_DB410C_FIRMWARE_SOURCE)
	mv $(@D)/$(QCOM_DB410C_FIRMWARE_BASE)/* $(@D)
	rmdir $(@D)/$(QCOM_DB410C_FIRMWARE_BASE)
endef

# Install the Wifi/Bt firmware blobs to target. These commands are
# based on firmware-qcom-dragonboard410c_*.bb in the OpenEmbedded
# meta-qcom layer, see https://github.com/ndechesne/meta-qcom
define QCOM_DB410C_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 \
		$(@D)/efs-seed/fs_image_linux.tar.gz.mbn.img \
		$(TARGET_DIR)/boot/modem_fsg

	$(INSTALL) -d $(TARGET_DIR)/lib/firmware
	cp -r $(@D)/proprietary-linux/wlan \
		$(TARGET_DIR)/lib/firmware/

	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/qcom/msm8916
	MTOOLS_SKIP_CHECK=1 $(HOST_DIR)/bin/mcopy -n -i \
		$(@D)/bootloaders-linux/NON-HLOS.bin \
		::image/modem.* ::image/mba.mbn ::image/wcnss.* \
		$(TARGET_DIR)/lib/firmware/qcom/msm8916
endef

$(eval $(generic-package))
