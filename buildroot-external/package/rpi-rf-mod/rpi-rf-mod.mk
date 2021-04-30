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

RPI_RF_MOD_VERSION = 3b0311063973669d0b5310a3d3e4b6280ac4f438
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
else ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_ODROID-C4),y)
  # Odroid C4 DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod-odroid-c4
else ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_ODROID-N2),y)
  # Odroid N2/N2+ DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod-odroid-n2
else ifeq ($(BR2_PACKAGE_RPI_RF_MOD_DTS_ODROID-C2),y)
  # Odroid C2 DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod-odroid-c2
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
