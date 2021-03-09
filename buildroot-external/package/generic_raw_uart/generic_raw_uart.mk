#############################################################
#
# Generic raw uart kernel module for low-latency uart
# communication with a RPI-RF-MOD/HM-MOD-RPI-PCB
#
# Copyright (c) 2020 Alexander Reinert
# https://github.com/alexreinert/piVCCU/tree/master/kernel
#
# Uses parts of bcm2835_raw_uart.c
# Copyright (c) 2015 eQ-3 Entwicklung GmbH
# https://github.com/eq-3/occu/tree/master/KernelDrivers
# https://github.com/jens-maus/RaspberryMatic/tree/master/buildroot-external/package/bcm2835_raw_uart
#
#############################################################

GENERIC_RAW_UART_VERSION = 0fc14a2131da3b14d91407ef803ded5dc3a9ff80
GENERIC_RAW_UART_SITE = $(call github,alexreinert,piVCCU,$(GENERIC_RAW_UART_VERSION))
GENERIC_RAW_UART_LICENSE = GPL2
GENERIC_RAW_UART_DEPENDENCIES = host-dtc
#GENERIC_RAW_UART_LICENSE_FILES = LICENSE
GENERIC_RAW_UART_MODULE_SUBDIRS = kernel
GENERIC_RAW_UART_INSTALL_IMAGES = YES

# RaspberryPi DTS file
ifneq (,$(findstring raspberrypi,$(BR2_PACKAGE_HASSIO_MACHINE)))
  GENERIC_RAW_UART_DTS_FILE = pivccu-raspberrypi
endif

# Tinkerboard DTS file
ifneq (,$(findstring tinker,$(BR2_PACKAGE_HASSIO_MACHINE)))
  GENERIC_RAW_UART_DTS_FILE = pivccu-tinkerboard
endif

define GENERIC_RAW_UART_BUILD_CMDS
  if [[ -n "$(GENERIC_RAW_UART_DTS_FILE)" ]]; then \
    $(HOST_DIR)/bin/dtc -@ -I dts -O dtb -W no-unit_address_vs_reg -o $(@D)/dts/$(GENERIC_RAW_UART_DTS_FILE).dtbo $(@D)/dts/$(GENERIC_RAW_UART_DTS_FILE).dts; \
  fi
endef

define GENERIC_RAW_UART_INSTALL_IMAGES_CMDS
  if [[ -n "$(GENERIC_RAW_UART_DTS_FILE)" ]]; then \
    $(INSTALL) -D -m 0644 $(@D)/dts/$(GENERIC_RAW_UART_DTS_FILE).dtbo $(BINARIES_DIR)/; \
  fi
endef

$(eval $(kernel-module))
$(eval $(generic-package))
