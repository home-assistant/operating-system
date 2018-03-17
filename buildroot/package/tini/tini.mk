################################################################################
#
# tini
#
################################################################################

TINI_VERSION = v0.17.0
TINI_SITE = $(call github,krallin,tini,$(TINI_VERSION))

TINI_LICENSE = MIT
TINI_LICENSE_FILES = LICENSE

TINI_CFLAGS = $(TARGET_CFLAGS) -DTINI_VERSION=\"$(TINI_VERSION)\" -DTINI_GIT=\"\"
TINI_CFLAGS += -static

ifeq ($(BR2_PACKAGE_TINI_MINIMAL),y)
TINI_CFLAGS += -DTINI_MINIMAL
endif

define TINI_CONFIGURE_CMDS
	printf "#pragma once\n" > $(@D)/src/tiniConfig.h
endef

define TINI_BUILD_CMDS
	$(TARGET_CC) \
		$(TINI_CFLAGS) \
		-o $(@D)/tini $(@D)/src/tini.c
endef

define TINI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tini $(TARGET_DIR)/usr/bin/tini
endef

# Tini's CMakeLists.txt is not suitable for Buildroot.
$(eval $(generic-package))
