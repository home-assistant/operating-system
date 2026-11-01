################################################################################
#
# Generic raw uart kernel module for low-latency uart
# communication with a RPI-RF-MOD/HM-MOD-RPI-PCB/HmIP-RFUSB
#
# Copyright (c) 2021-2023 Alexander Reinert
# https://github.com/alexreinert/piVCCU/tree/master/kernel
# Maintained fork: https://github.com/OpenCCU/piVCCU/tree/master/kernel
#
# Uses parts of bcm2835_raw_uart.c
# Copyright (c) 2015 eQ-3 Entwicklung GmbH
# https://github.com/eq-3/occu/tree/master/KernelDrivers
# https://github.com/openccu/openccu/tree/master/buildroot-external/package/bcm2835_raw_uart
#
################################################################################

GENERIC_RAW_UART_VERSION = f7faefd1443e3a1ac88b0e0a1a31b25342c80b50
GENERIC_RAW_UART_SITE = $(call github,OpenCCU,piVCCU,$(GENERIC_RAW_UART_VERSION))
GENERIC_RAW_UART_LICENSE = GPL2
GENERIC_RAW_UART_LICENSE_FILES = LICENSE
GENERIC_RAW_UART_MODULE_SUBDIRS = kernel

# only build the required modules, and the SoC specific raw uart
# drivers (pl011/dw_apb/meson) only if the target kernel supports the SoC
GENERIC_RAW_UART_MODULE_MAKE_OPTS = \
	PIVCCU_MODULES="generic_raw_uart pl011_raw_uart dw_apb_raw_uart meson_raw_uart rpi_rf_mod_led rpi_rf_mod_rgb dummy_rx8130 hb_rf_usb hb_rf_usb_2 hb_rf_eth" \
	PIVCCU_SOC_UART_AUTO=y

$(eval $(kernel-module))
$(eval $(generic-package))
