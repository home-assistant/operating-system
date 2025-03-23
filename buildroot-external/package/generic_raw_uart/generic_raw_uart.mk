################################################################################
#
# Generic raw uart kernel module for low-latency uart
# communication with a RPI-RF-MOD/HM-MOD-RPI-PCB/HmIP-RFUSB
#
# Copyright (c) 2021-2023 Alexander Reinert
# https://github.com/alexreinert/piVCCU/tree/master/kernel
#
# Uses parts of bcm2835_raw_uart.c
# Copyright (c) 2015 eQ-3 Entwicklung GmbH
# https://github.com/eq-3/occu/tree/master/KernelDrivers
# https://github.com/jens-maus/RaspberryMatic/tree/master/buildroot-external/package/bcm2835_raw_uart
#
################################################################################

GENERIC_RAW_UART_VERSION = b80aacfb75e9689d14d4e2c94380728816c6313e
GENERIC_RAW_UART_SITE = $(call github,alexreinert,piVCCU,$(GENERIC_RAW_UART_VERSION))
GENERIC_RAW_UART_LICENSE = GPL2
GENERIC_RAW_UART_LICENSE_FILES = LICENSE
GENERIC_RAW_UART_MODULE_SUBDIRS = kernel

$(eval $(kernel-module))
$(eval $(generic-package))
