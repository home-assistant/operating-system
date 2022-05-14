################################################################################
#
# eQ-3 char loopback kernel module for HomeMatic/homematicIP
# dual stack implementations for the RPI-RF-MOD/HM-MOD-RPI-PCB
#
# Copyright (c) 2015 by eQ-3 Entwicklung GmbH
# https://github.com/eq-3/occu/tree/master/KernelDrivers
#
################################################################################

EQ3_CHAR_LOOP_VERSION = e60183fc5b8375d9eea185c716f716c07657fa00
EQ3_CHAR_LOOP_SITE = $(call github,eq-3,occu,$(EQ3_CHAR_LOOP_VERSION))
EQ3_CHAR_LOOP_LICENSE = LGPL-2.1+ (kernel drivers)
EQ3_CHAR_LOOP_LICENSE_FILES = LicenseDE.txt
EQ3_CHAR_LOOP_MODULE_SUBDIRS = KernelDrivers

$(eval $(kernel-module))
$(eval $(generic-package))
