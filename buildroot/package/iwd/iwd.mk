################################################################################
#
# iwd
#
################################################################################

IWD_VERSION = 1.10
IWD_SITE = https://git.kernel.org/pub/scm/network/wireless/iwd.git
IWD_SITE_METHOD = git
IWD_LICENSE = LGPL-2.1+
IWD_LICENSE_FILES = COPYING
IWD_CPE_ID_VENDOR = intel
IWD_CPE_ID_PRODUCT = inet_wireless_daemon
# sources from git, no configure script provided
IWD_AUTORECONF = YES
IWD_SELINUX_MODULES = networkmanager

IWD_CONF_OPTS = \
	--disable-manual-pages \
	--enable-external-ell
IWD_DEPENDENCIES = ell

# autoreconf requires an existing build-aux directory
define IWD_MKDIR_BUILD_AUX
	mkdir -p $(@D)/build-aux
endef
IWD_POST_PATCH_HOOKS += IWD_MKDIR_BUILD_AUX

ifeq ($(BR2_PACKAGE_DBUS),y)
IWD_CONF_OPTS += --enable-dbus-policy --with-dbus-datadir=/usr/share
IWD_DEPENDENCIES += dbus
else
IWD_CONF_OPTS += --disable-dbus-policy
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
# iwd client depends on readline (GPL-3.0+)
IWD_LICENSE += , GPL-3.0+ (client)
IWD_CONF_OPTS += --enable-client
IWD_DEPENDENCIES += readline
else
IWD_CONF_OPTS += --disable-client
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
IWD_CONF_OPTS += --enable-systemd-service
IWD_DEPENDENCIES += systemd
else
IWD_CONF_OPTS += --disable-systemd-service
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_RESOLVED),y)
IWD_RESOLV_SERVICE = systemd
else
IWD_RESOLV_SERVICE = resolvconf
endif

define IWD_INSTALL_CONFIG_FILE
	$(INSTALL) -D -m 644 package/iwd/main.conf $(TARGET_DIR)/etc/iwd/main.conf
	$(SED) 's,__RESOLV_SERVICE__,$(IWD_RESOLV_SERVICE),' $(TARGET_DIR)/etc/iwd/main.conf
endef

IWD_POST_INSTALL_TARGET_HOOKS += IWD_INSTALL_CONFIG_FILE

define IWD_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/iwd/S40iwd \
		$(TARGET_DIR)/etc/init.d/S40iwd
	mkdir -p $(TARGET_DIR)/var/lib/iwd
	ln -sf /tmp/iwd/hotspot $(TARGET_DIR)/var/lib/iwd/hotspot
endef

$(eval $(autotools-package))
