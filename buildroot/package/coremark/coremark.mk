################################################################################
#
# CoreMark
#
################################################################################

COREMARK_VERSION = 1.01
COREMARK_SITE = $(call github,eembc,coremark,v$(COREMARK_VERSION))
COREMARK_LICENSE = Apache-2.0
COREMARK_LICENSE_FILES = LICENSE.md

define COREMARK_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" -C $(@D) \
		PORT_DIR=linux$(if $(BR2_ARCH_IS_64),64) EXE= link
endef

define COREMARK_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/coremark $(TARGET_DIR)/usr/bin/coremark
endef

$(eval $(generic-package))
