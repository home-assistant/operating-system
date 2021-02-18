ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_VARIANT_PI4),y)
RPI_FIRMWARE_BOOT_FILES = \
	start4.elf \
	start4x.elf \
	start4cd.elf \
	fixup4.dat \
	fixup4x.dat \
	fixup4cd.dat
else
RPI_FIRMWARE_BOOT_FILES = \
	start.elf \
	start_x.elf \
	start_cd.elf \
	fixup.dat \
	fixup_x.dat \
	fixup_cd.dat
endif

define RPI_FIRMWARE_INSTALL_IMAGES_CMDS
	$(foreach firmware,$(RPI_FIRMWARE_BOOT_FILES), \
		$(INSTALL) -D -m 0644 $(@D)/boot/$(firmware) $(BINARIES_DIR)/rpi-firmware/$(firmware)
	)
	$(RPI_FIRMWARE_INSTALL_BOOTCODE_BIN)
	$(RPI_FIRMWARE_INSTALL_DTB)
	$(RPI_FIRMWARE_INSTALL_DTB_OVERLAYS)
endef

