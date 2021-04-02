#############################################################
#
# eQ-3 char loopback kernel module for HomeMatic/homematicIP
# dual stack implementations for the RPI-RF-MOD/HM-MOD-RPI-PCB
#
# Copyright (c) 2015 by eQ-3 Entwicklung GmbH
# https://github.com/eq-3/occu/tree/master/KernelDrivers
#
#############################################################

EQ3_CHAR_LOOP_VERSION = 8cb51174c2bc8c4b33df50a96b82c90e8092f79c
EQ3_CHAR_LOOP_SITE = $(call github,eq-3,occu,$(EQ3_CHAR_LOOP_VERSION))
EQ3_CHAR_LOOP_LICENSE = GPL2
#EQ3_CHAR_LOOP_LICENSE_FILES = LICENSE
EQ3_CHAR_LOOP_MODULE_SUBDIRS = KernelDrivers

$(eval $(kernel-module))
$(eval $(generic-package))
