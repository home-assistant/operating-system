#############################################################
#
# Meta package for RPI-RF-MOD/HM-MOD-RPI-PCB device support
# for HomeMatic/homematicIP connectivity.
#
# This includes compiling of required device tree overlays for
# selected platforms
#
# Copyright (c) 2018-2021 Jens Maus <mail@jens-maus.de>
# https://github.com/jens-maus/RaspberryMatic/tree/master/buildroot-external/package/rpi-rf-mod
#
#############################################################

RPI_RF_MOD_VERSION = 97bd31203445d14e3d97e1d6e7a0bcf93b400c2e
RPI_RF_MOD_SITE = $(call github,jens-maus,RaspberryMatic,$(RPI_RF_MOD_VERSION))
RPI_RF_MOD_LICENSE = Apache-2.0
RPI_RF_MOD_DEPENDENCIES = host-dtc
#RPI_RF_MOD_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_RPI),y)
  # RaspberryPi DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod
else ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_TINKER),y)
  # ASUS Tinkerboard DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod-tinker
endif

define RPI_RF_MOD_BUILD_CMDS
  if [[ -n "$(RPI_RF_MOD_DTS_FILE)" ]]; then \
    $(HOST_DIR)/bin/dtc -@ -I dts -O dtb -W no-unit_address_vs_reg -o $(@D)/buildroot-external/package/rpi-rf-mod/dts/rpi-rf-mod.dtbo $(@D)/buildroot-external/package/rpi-rf-mod/dts/$(RPI_RF_MOD_DTS_FILE).dts; \
  fi
endef

define RPI_RF_MOD_INSTALL_TARGET_CMDS
  if [[ -n "$(RPI_RF_MOD_DTS_FILE)" ]]; then \
    $(INSTALL) -D -m 0644 $(@D)/buildroot-external/package/rpi-rf-mod/dts/rpi-rf-mod.dtbo $(BINARIES_DIR)/; \
  fi
endef

$(eval $(generic-package))
