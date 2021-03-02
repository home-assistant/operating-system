################################################################################
#
# qoriq-rcw
#
################################################################################

QORIQ_RCW_VERSION = LSDK-20.12
QORIQ_RCW_SITE = https://source.codeaurora.org/external/qoriq/qoriq-components/rcw
QORIQ_RCW_SITE_METHOD = git
QORIQ_RCW_LICENSE = BSD-3-Clause
QORIQ_RCW_LICENSE_FILES = LICENSE

HOST_QORIQ_RCW_DEPENDENCIES = $(BR2_PYTHON3_HOST_DEPENDENCY)

QORIQ_RCW_FILES = $(call qstrip,$(BR2_PACKAGE_HOST_QORIQ_RCW_CUSTOM_PATH))

ifneq ($(QORIQ_RCW_FILES),)
QORIQ_RCW_INCLUDES = $(filter-out %.rcw,$(QORIQ_RCW_FILES))
# Get the name of the custom rcw file from the custom list
QORIQ_RCW_PROJECT = $(notdir $(filter %.rcw,$(QORIQ_RCW_FILES)))

# Error if there are no or more than one .rcw file
ifeq ($(BR_BUILDING),y)
ifneq ($(words $(QORIQ_RCW_PROJECT)),1)
$(error BR2_PACKAGE_HOST_QORIQ_RCW_CUSTOM_PATH must have exactly one .rcw file)
endif
endif

ifneq ($(QORIQ_RCW_INCLUDES),)
define HOST_QORIQ_RCW_ADD_CUSTOM_RCW_INCLUDES
	mkdir -p $(@D)/custom_board
	cp -f $(QORIQ_RCW_INCLUDES) $(@D)/custom_board
endef
HOST_QORIQ_RCW_POST_PATCH_HOOKS += HOST_QORIQ_RCW_ADD_CUSTOM_RCW_INCLUDES
endif

define HOST_QORIQ_RCW_ADD_CUSTOM_RCW_FILES
	mkdir -p $(@D)/custom_board/rcw
	cp -f $(filter %.rcw,$(QORIQ_RCW_FILES)) $(@D)/custom_board/rcw
endef
HOST_QORIQ_RCW_POST_PATCH_HOOKS += HOST_QORIQ_RCW_ADD_CUSTOM_RCW_FILES

# rcw.py is a python3-only script, and we can be using either the
# system-provided python3, or our own built with host-python3.
# Fortunately, rcw.py uses #!/usr/bin/env python3, so it will
# easily find it from PATH.
define HOST_QORIQ_RCW_BUILD_CMDS
	PATH=$(BR_PATH) \
	$(@D)/rcw.py \
		-i $(@D)/custom_board/rcw/$(QORIQ_RCW_PROJECT) \
		-I $(@D)/custom_board -o $(@D)/PBL.bin
endef

define HOST_QORIQ_RCW_INSTALL_DELIVERY_FILE
	$(INSTALL) -D -m 0644 $(@D)/PBL.bin $(BINARIES_DIR)/PBL.bin
endef
endif

# Copy source files and script into $(HOST_DIR)/share/rcw/ so a developer
# could use a post image or SDK to build/install PBL files.
define HOST_QORIQ_RCW_INSTALL_CMDS
	mkdir -p  $(HOST_DIR)/share/rcw
	cp -a $(@D)/* $(HOST_DIR)/share/rcw
	$(HOST_QORIQ_RCW_INSTALL_DELIVERY_FILE)
endef

$(eval $(host-generic-package))
