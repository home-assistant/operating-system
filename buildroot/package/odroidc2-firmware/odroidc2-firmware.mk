################################################################################
#
# odroidc2-firmware
#
################################################################################

ODROIDC2_FIRMWARE_VERSION = s905_6.0.1_v5.5
ODROIDC2_FIRMWARE_SITE = $(call github,hardkernel,u-boot,$(ODROIDC2_FIRMWARE_VERSION))
ODROIDC2_FIRMWARE_INSTALL_IMAGES = YES

define ODROIDC2_FIRMWARE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) \
		-C $(@D)/tools/fip_create/
endef

ODROIDC2_FIRMWARE_FILES = \
	fip/gxb/bl301.bin \
	fip/gxb/bl30.bin \
	fip/gxb/bl31.bin \
	fip/gxb/bl2.package \
	sd_fuse/bl1.bin.hardkernel

define ODROIDC2_FIRMWARE_INSTALL_IMAGES_CMDS
	$(foreach f,$(ODROIDC2_FIRMWARE_FILES), \
		$(INSTALL) -D -m 0644 $(@D)/$(f) $(BINARIES_DIR)/$(notdir $(f))
	)
	$(INSTALL) -D -m0755 $(@D)/tools/fip_create/fip_create \
		$(HOST_DIR)/bin/fip_create
endef

$(eval $(generic-package))
