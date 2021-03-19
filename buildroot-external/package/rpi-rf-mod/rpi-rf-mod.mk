#############################################################
#
# Device tree overlay support for RPI-RF-MOD/HM-MOD-RPI-PCB
# rf modules for HomeMatic/homematicIP connectivity.
#
# Copyright (c) 2018-2021 Jens Maus <mail@jens-maus.de>
# https://github.com/jens-maus/RaspberryMatic/tree/master/buildroot-external/package/rpi-rf-mod
#
#############################################################

RPI_RF_MOD_VERSION = 1.4.0
RPI_RF_MOD_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/rpi-rf-mod
RPI_RF_MOD_SITE_METHOD = local
RPI_RF_MOD_LICENSE = Apache-2.0
#RPI_RF_MOD_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_RPI_RF_MOD_TARGET_RPI),y)
  # RaspberryPi DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod
else ifeq ($(BR2_PACKAGE_RPI_RF_MOD_TARGET_TINKER),y)
  # ASUS Tinkerboard DTS file
  RPI_RF_MOD_DTS_FILE = rpi-rf-mod-tinker
endif

define RPI_RF_MOD_BUILD_CMDS
  if [[ -n "$(RPI_RF_MOD_DTS_FILE)" ]]; then \
    $(HOST_DIR)/bin/dtc -@ -I dts -O dtb -W no-unit_address_vs_reg -o $(@D)/dts/$(RPI_RF_MOD_DTS_FILE).dtbo $(@D)/dts/$(RPI_RF_MOD_DTS_FILE).dts; \
  fi
endef

define RPI_RF_MOD_INSTALL_TARGET_CMDS
  if [[ -n "$(RPI_RF_MOD_DTS_FILE)" ]]; then \
    $(INSTALL) -D -m 0644 $(@D)/dts/$(RPI_RF_MOD_DTS_FILE).dtbo $(BINARIES_DIR)/; \
  fi
endef

$(eval $(generic-package))
