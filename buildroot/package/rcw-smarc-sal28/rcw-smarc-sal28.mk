################################################################################
#
# rcw-smarc-sal28
#
################################################################################

RCW_SMARC_SAL28_VERSION = 10
RCW_SMARC_SAL28_SITE = $(call github,kontron,rcw-smarc-sal28,v$(RCW_SMARC_SAL28_VERSION))
RCW_SMARC_SAL28_LICENSE = BSD-2-Clause
RCW_SMARC_SAL28_LICENSE_FILES = COPYING
RCW_SMARC_SAL28_INSTALL_TARGET = NO
RCW_SMARC_SAL28_INSTALL_IMAGES = YES

RCW_SMARC_SAL28_BOOT_VARIANT = $(call qstrip,$(BR2_PACKAGE_RCW_SMARC_SAL28_BOOT_VARIANT))

ifeq ($(BR2_PACKAGE_RCW_SMARC_SAL28_BUILD_UPDATE_SCRIPT),y)
RCW_SMARC_SAL28_DEPENDENCIES = host-uboot-tools
define RCW_SMARC_SAL28_UPDATE_SCRIPT_BUILD_CMDS
	MKIMAGE=$(HOST_DIR)/bin/mkimage $(MAKE) -C $(@D)/contrib all
endef
define RCW_SMARC_SAL28_UPDATE_SCRIPT_INSTALL_CMDS
	$(INSTALL) -D -m 0644 $(@D)/contrib/update-rcw.img $(BINARIES_DIR)/
endef
endif

define RCW_SMARC_SAL28_BUILD_CMDS
	$(RCW_SMARC_SAL28_UPDATE_SCRIPT_BUILD_CMDS)
endef

define RCW_SMARC_SAL28_INSTALL_IMAGES_CMDS
	$(INSTALL) -d $(BINARIES_DIR)/rcw
	$(INSTALL) -D -m 0644 $(@D)/sl28-*.bin $(BINARIES_DIR)/rcw/
	ln -sf rcw/sl28-$(RCW_SMARC_SAL28_BOOT_VARIANT).bin $(BINARIES_DIR)/rcw.bin
	$(RCW_SMARC_SAL28_UPDATE_SCRIPT_INSTALL_CMDS)
endef

$(eval $(generic-package))
