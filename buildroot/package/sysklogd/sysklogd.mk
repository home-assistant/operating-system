################################################################################
#
# sysklogd
#
################################################################################

SYSKLOGD_VERSION = 2.2.3
SYSKLOGD_SITE = https://github.com/troglobit/sysklogd/releases/download/v$(SYSKLOGD_VERSION)
SYSKLOGD_LICENSE = BSD-3-Clause
SYSKLOGD_LICENSE_FILES = LICENSE
SYSKLOGD_CPE_ID_VENDOR = sysklogd_project

# Busybox install logger in /usr/bin, and syslogd in /sbin, so install in
# the same locations so that busybox does not install its applets in there.
SYSKLOGD_CONF_OPTS = \
	--bindir=/usr/bin \
	--sbindir=/sbin \
	--with-suspend-time=$(BR2_PACKAGE_SYSKLOGD_REMOTE_DELAY)

# Disable/Enable utilities
ifeq ($(BR2_PACKAGE_SYSKLOGD_LOGGER),y)
SYSKLOGD_CONF_OPTS += --with-logger
else
SYSKLOGD_CONF_OPTS += --without-logger
endif

define SYSKLOGD_INSTALL_SAMPLE_CONFIG
	$(INSTALL) -D -m 0644 $(@D)/syslog.conf \
		$(TARGET_DIR)/etc/syslog.conf
endef

SYSKLOGD_POST_INSTALL_TARGET_HOOKS += SYSKLOGD_INSTALL_SAMPLE_CONFIG

define SYSKLOGD_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/sysklogd/S01syslogd \
		$(TARGET_DIR)/etc/init.d/S01syslogd
endef

define SYSKLOGD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(SYSKLOGD_PKGDIR)/syslogd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/syslogd.service
endef

$(eval $(autotools-package))
