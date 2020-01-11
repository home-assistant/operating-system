################################################################################
#
# neardal
#
################################################################################

NEARDAL_VERSION = 33b54a55032b047fd885a5eb3592c169c0056c49
NEARDAL_SITE = $(call github,connectivity,neardal,$(NEARDAL_VERSION))
NEARDAL_INSTALL_STAGING = YES
NEARDAL_LICENSE = LGPL-2.0
NEARDAL_LICENSE_FILES = COPYING

NEARDAL_DEPENDENCIES = host-pkgconf dbus dbus-glib libedit
NEARDAL_AUTORECONF = YES

define NEARDAL_INSTALL_NCL
	$(INSTALL) -m 0755 -D $(@D)/ncl/ncl $(TARGET_DIR)/usr/bin/ncl
endef

ifeq ($(BR2_PACKAGE_NEARDAL_NCL),y)
NEARDAL_POST_INSTALL_TARGET_HOOKS += NEARDAL_INSTALL_NCL
endif

$(eval $(autotools-package))
