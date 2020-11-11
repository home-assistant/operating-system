################################################################################
#
# vpnc
#
################################################################################

VPNC_VERSION = 0.5.3r550-2jnpr1
VPNC_SITE = $(call github,ndpgroup,vpnc,$(VPNC_VERSION))
VPNC_LICENSE = GPL-2.0+
VPNC_LICENSE_FILES = COPYING

VPNC_DEPENDENCIES = libgcrypt libgpg-error gnutls host-pkgconf

define VPNC_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(TARGET_CONFIGURE_OPTS) \
		LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config \
		VERSION=$(VPNC_VERSION) MANS=
endef

define VPNC_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install $(TARGET_CONFIGURE_OPTS) \
		VERSION=$(VPNC_VERSION) MANS= \
		DESTDIR="$(TARGET_DIR)" PREFIX=/usr
endef

$(eval $(generic-package))
