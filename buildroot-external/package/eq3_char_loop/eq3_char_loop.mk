################################################################################
#
# eQ-3 char loopback kernel module for HomeMatic/homematicIP
# dual stack implementations for the RPI-RF-MOD/HM-MOD-RPI-PCB
#
# Copyright (c) 2015 by eQ-3 Entwicklung GmbH
# https://github.com/OpenCCU/OpenCCU-Base/tree/main/src/eq3_char_loop
#
################################################################################

# Only the single driver source file is downloaded at the pinned
# OpenCCU-Base revision instead of the whole OpenCCU-Base repository.
EQ3_CHAR_LOOP_VERSION = 60dbdc7e81996cd17acd9105a6a249be64b12fd4
EQ3_CHAR_LOOP_SITE = https://raw.githubusercontent.com/OpenCCU/OpenCCU-Base/$(EQ3_CHAR_LOOP_VERSION)/src/eq3_char_loop
EQ3_CHAR_LOOP_SOURCE = eq3_char_loop.c
EQ3_CHAR_LOOP_LICENSE = GPL-2.0+
EQ3_CHAR_LOOP_LICENSE_FILES = eq3_char_loop.c
# The file name does not change between revisions, so each revision gets its
# own download directory to never reuse a cached file of another revision.
EQ3_CHAR_LOOP_DL_SUBDIR = eq3_char_loop/$(EQ3_CHAR_LOOP_VERSION)

define EQ3_CHAR_LOOP_EXTRACT_CMDS
	cp $(EQ3_CHAR_LOOP_DL_DIR)/$(EQ3_CHAR_LOOP_SOURCE) $(@D)/
	echo 'obj-m += eq3_char_loop.o' > $(@D)/Makefile
endef

$(eval $(kernel-module))
$(eval $(generic-package))
