#############################################################
#
# eQ-3 char loopback kernel module for HomeMatic/homematicIP
# dual stack implementations for the RPI-RF-MOD/HM-MOD-RPI-PCB
#
# Copyright (c) 2015 by eQ-3 Entwicklung GmbH
# https://github.com/eq-3/occu/tree/master/KernelDrivers
#
#############################################################

EQ3_CHAR_LOOP_VERSION = 1.1.0
EQ3_CHAR_LOOP_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/eq3_char_loop
EQ3_CHAR_LOOP_SITE_METHOD = local
EQ3_CHAR_LOOP_LICENSE = GPL2
#EQ3_CHAR_LOOP_LICENSE_FILES = LICENSE
EQ3_CHAR_LOOP_MODULE_SUBDIRS = .

$(eval $(kernel-module))
$(eval $(generic-package))
