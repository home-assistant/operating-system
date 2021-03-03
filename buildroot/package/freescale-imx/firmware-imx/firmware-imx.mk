################################################################################
#
# firmware-imx
#
################################################################################

FIRMWARE_IMX_VERSION = 8.10
FIRMWARE_IMX_SITE = $(FREESCALE_IMX_SITE)
FIRMWARE_IMX_SOURCE = firmware-imx-$(FIRMWARE_IMX_VERSION).bin

FIRMWARE_IMX_LICENSE = NXP Semiconductor Software License Agreement
FIRMWARE_IMX_LICENSE_FILES = EULA COPYING
FIRMWARE_IMX_REDISTRIBUTE = NO

FIRMWARE_IMX_INSTALL_IMAGES = YES

define FIRMWARE_IMX_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(FIRMWARE_IMX_DL_DIR)/$(FIRMWARE_IMX_SOURCE))
endef

#
# DDR firmware
#

define FIRMWARE_IMX_PREPARE_DDR_FW
	$(TARGET_OBJCOPY) -I binary -O binary \
		--pad-to $(BR2_PACKAGE_FIRMWARE_IMX_IMEM_LEN) --gap-fill=0x0 \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(1)).bin \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(1))_pad.bin
	$(TARGET_OBJCOPY) -I binary -O binary \
		--pad-to $(BR2_PACKAGE_FIRMWARE_IMX_DMEM_LEN) --gap-fill=0x0 \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(2)).bin \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(2))_pad.bin
	cat $(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(1))_pad.bin \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(2))_pad.bin > \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(3)).bin
endef

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_LPDDR4),y)
FIRMWARE_IMX_DDRFW_DIR = $(@D)/firmware/ddr/synopsys

define FIRMWARE_IMX_INSTALL_IMAGE_DDR_FW
	# Create padded versions of lpddr4_pmu_* and generate lpddr4_pmu_train_fw.bin.
	# lpddr4_pmu_train_fw.bin is needed when generating imx8-boot-sd.bin
	# which is done in post-image script.
	$(call FIRMWARE_IMX_PREPARE_DDR_FW, \
		lpddr4_pmu_train_1d_imem,lpddr4_pmu_train_1d_dmem,lpddr4_pmu_train_1d_fw)
	$(call FIRMWARE_IMX_PREPARE_DDR_FW, \
		lpddr4_pmu_train_2d_imem,lpddr4_pmu_train_2d_dmem,lpddr4_pmu_train_2d_fw)
	cat $(FIRMWARE_IMX_DDRFW_DIR)/lpddr4_pmu_train_1d_fw.bin \
		$(FIRMWARE_IMX_DDRFW_DIR)/lpddr4_pmu_train_2d_fw.bin > \
		$(BINARIES_DIR)/lpddr4_pmu_train_fw.bin
	ln -sf $(BINARIES_DIR)/lpddr4_pmu_train_fw.bin $(BINARIES_DIR)/ddr_fw.bin
endef
endif

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_DDR4),y)
FIRMWARE_IMX_DDRFW_DIR = $(@D)/firmware/ddr/synopsys

define FIRMWARE_IMX_INSTALL_IMAGE_DDR_FW
	# Create padded versions of ddr4_* and generate ddr4_fw.bin.
	# ddr4_fw.bin is needed when generating imx8-boot-sd.bin
	# which is done in post-image script.
	$(call FIRMWARE_IMX_PREPARE_DDR_FW, \
		ddr4_imem_1d_201810,ddr4_dmem_1d_201810,ddr4_1d_201810_fw)
	$(call FIRMWARE_IMX_PREPARE_DDR_FW, \
		ddr4_imem_2d_201810,ddr4_dmem_2d_201810,ddr4_2d_201810_fw)
	cat $(FIRMWARE_IMX_DDRFW_DIR)/ddr4_1d_201810_fw.bin \
		$(FIRMWARE_IMX_DDRFW_DIR)/ddr4_2d_201810_fw.bin > \
		$(BINARIES_DIR)/ddr4_201810_fw.bin
	ln -sf $(BINARIES_DIR)/ddr4_201810_fw.bin $(BINARIES_DIR)/ddr_fw.bin
endef
endif

#
# HDMI firmware
#

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_NEEDS_HDMI_FW),y)
define FIRMWARE_IMX_INSTALL_IMAGE_HDMI_FW
	cp $(@D)/firmware/hdmi/cadence/signed_hdmi_imx8m.bin \
		$(BINARIES_DIR)/signed_hdmi_imx8m.bin
endef
endif

#
# EPDC firmware
#

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_NEEDS_EPDC_FW),y)
define FIRMWARE_IMX_INSTALL_TARGET_EPDC_FW
	mkdir -p $(TARGET_DIR)/lib/firmware/imx
	cp -r $(@D)/firmware/epdc $(TARGET_DIR)/lib/firmware/imx
	mv $(TARGET_DIR)/lib/firmware/imx/epdc/epdc_ED060XH2C1.fw.nonrestricted \
		$(TARGET_DIR)/lib/firmware/imx/epdc/epdc_ED060XH2C1.fw
endef
endif

#
# SDMA firmware
#

FIRMWARE_IMX_SDMA_FW_NAME = $(call qstrip,$(BR2_PACKAGE_FIRMWARE_IMX_SDMA_FW_NAME))
ifneq ($(FIRMWARE_IMX_SDMA_FW_NAME),)
define FIRMWARE_IMX_INSTALL_TARGET_SDMA_FW
	mkdir -p $(TARGET_DIR)/lib/firmware/imx/sdma
	cp -r $(@D)/firmware/sdma/sdma-$(FIRMWARE_IMX_SDMA_FW_NAME)*.bin \
	       $(TARGET_DIR)/lib/firmware/imx/sdma/
endef
endif

#
# VPU firmware
#

FIRMWARE_IMX_VPU_FW_NAME = $(call qstrip,$(BR2_PACKAGE_FIRMWARE_IMX_VPU_FW_NAME))
ifneq ($(FIRMWARE_IMX_VPU_FW_NAME),)
define FIRMWARE_IMX_INSTALL_TARGET_VPU_FW
	mkdir -p $(TARGET_DIR)/lib/firmware/vpu
	for i in $$(find $(@D)/firmware/vpu/vpu_fw_$(FIRMWARE_IMX_VPU_FW_NAME)*.bin); do \
		cp $$i $(TARGET_DIR)/lib/firmware/vpu/ ; \
		ln -sf vpu/$$(basename $$i) $(TARGET_DIR)/lib/firmware/$$(basename $$i) ; \
	done
endef
endif

define FIRMWARE_IMX_INSTALL_IMAGES_CMDS
	$(FIRMWARE_IMX_INSTALL_IMAGE_DDR_FW)
	$(FIRMWARE_IMX_INSTALL_IMAGE_HDMI_FW)
endef

define FIRMWARE_IMX_INSTALL_TARGET_CMDS
	$(FIRMWARE_IMX_INSTALL_TARGET_EPDC_FW)
	$(FIRMWARE_IMX_INSTALL_TARGET_SDMA_FW)
	$(FIRMWARE_IMX_INSTALL_TARGET_VPU_FW)
endef

$(eval $(generic-package))
