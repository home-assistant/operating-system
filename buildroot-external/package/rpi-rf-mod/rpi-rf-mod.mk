################################################################################
#
# Meta package for RPI-RF-MOD/HM-MOD-RPI-PCB device support
# for HomeMatic/homematicIP connectivity.
#
# This includes compiling of required device tree overlays for
# selected platforms
#
# Copyright (c) 2018-2023 Jens Maus <mail@jens-maus.de>
# https://github.com/OpenCCU/OpenCCU/tree/master/buildroot-external/package/rpi-rf-mod
#
################################################################################

# Only the license and the device tree overlay source for the selected
# platform are downloaded at the pinned OpenCCU revision instead of the
# whole OpenCCU repository.
RPI_RF_MOD_VERSION = 392759206d11864d4108a211da007868ec4f55e2
RPI_RF_MOD_SITE = https://raw.githubusercontent.com/OpenCCU/OpenCCU/$(RPI_RF_MOD_VERSION)/buildroot-external/package/rpi-rf-mod
RPI_RF_MOD_SOURCE = LICENSE
RPI_RF_MOD_LICENSE = Apache-2.0
RPI_RF_MOD_LICENSE_FILES = LICENSE
RPI_RF_MOD_DEPENDENCIES = host-dtc
# The file names do not change between revisions, so each revision gets its
# own download directory to never reuse a cached file of another revision.
RPI_RF_MOD_DL_SUBDIR = rpi-rf-mod/$(RPI_RF_MOD_VERSION)

ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_RPI),y)
  # RaspberryPi DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod
else ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_ODROID_C4),y)
  # ODROID-C4 DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod-odroid-c4
else ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_ODROID_N2),y)
  # ODROID-N2/N2+ DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod-odroid-n2
else ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_ODROID_C2),y)
  # ODROID-C2 DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod-odroid-c2
else ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_YELLOW),y)
  # HomeAssistant Yellow DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod-yellow
else ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_TINKER),y)
  # ASUS Tinkerboard/S DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod-tinker
else ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_TINKER2),y)
  # ASUS Tinkerboard2/2S DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod-tinker2
endif

ifneq ($(RPI_RF_MOD_DTS_FILE),)
RPI_RF_MOD_EXTRA_DOWNLOADS = dts/$(RPI_RF_MOD_DTS_FILE).dts
endif

define RPI_RF_MOD_EXTRACT_CMDS
	cp $(RPI_RF_MOD_DL_DIR)/$(RPI_RF_MOD_SOURCE) $(@D)/
	if [[ -n "$(RPI_RF_MOD_DTS_FILE)" ]]; then \
		cp $(RPI_RF_MOD_DL_DIR)/$(RPI_RF_MOD_DTS_FILE).dts $(@D)/; \
	fi
endef

define RPI_RF_MOD_BUILD_CMDS
	if [[ -n "$(RPI_RF_MOD_DTS_FILE)" ]]; then \
		$(HOST_DIR)/bin/dtc -@ -I dts -O dtb -W no-unit_address_vs_reg -o $(@D)/rpi-rf-mod.dtbo $(@D)/$(RPI_RF_MOD_DTS_FILE).dts; \
	fi
endef

define RPI_RF_MOD_INSTALL_TARGET_CMDS
	if [[ -n "$(RPI_RF_MOD_DTS_FILE)" ]]; then \
		$(INSTALL) -D -m 0644 $(@D)/rpi-rf-mod.dtbo $(BINARIES_DIR)/; \
	fi
	$(INSTALL) -D -m 644 $(RPI_RF_MOD_PKGDIR)/82-rpi-rf-mod-leds.rules $(TARGET_DIR)/lib/udev/rules.d/
endef

$(eval $(generic-package))
