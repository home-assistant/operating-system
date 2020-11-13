################################################################################
#
# htpdate
#
################################################################################

HTPDATE_VERSION = 1.2.5
HTPDATE_SITE = $(call github,angeloc,htpdate,v$(HTPDATE_VERSION))
HTPDATE_LICENSE = GPL-2.0+
HTPDATE_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_OPENSSL),y)
HTPDATE_BUILD_OPTS = ENABLE_HTTPS=1
HTPDATE_DEPENDENCIES += openssl host-pkgconf
endif

define HTPDATE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(HTPDATE_BUILD_OPTS)
endef

define HTPDATE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define HTPDATE_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/htpdate/S43htpdate \
		$(TARGET_DIR)/etc/init.d/S43htpdate
endef

define HTPDATE_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/htpdate/htpdate.service \
		$(TARGET_DIR)/usr/lib/systemd/system/htpdate.service
endef

$(eval $(generic-package))
