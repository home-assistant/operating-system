################################################################################
#
# logrotate
#
################################################################################

LOGROTATE_VERSION = 3.18.0
LOGROTATE_SOURCE = logrotate-3.18.0.tar.xz
LOGROTATE_SITE = https://github.com/logrotate/logrotate/releases/download/$(LOGROTATE_VERSION)
LOGROTATE_LICENSE = GPL-2.0+
LOGROTATE_LICENSE_FILES = COPYING
LOGROTATE_CPE_ID_VENDOR = logrotate_project
LOGROTATE_DEPENDENCIES = popt host-pkgconf
LOGROTATE_SELINUX_MODULES = logrotate
LOGROTATE_CONF_ENV = LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs popt`"

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
LOGROTATE_CONF_OPTS += --with-selinux
LOGROTATE_DEPENDENCIES += libselinux
else
LOGROTATE_CONF_OPTS += --without-selinux
endif

ifeq ($(BR2_PACKAGE_ACL),y)
LOGROTATE_DEPENDENCIES += acl
LOGROTATE_CONF_OPTS += --with-acl
else
LOGROTATE_CONF_OPTS += --without-acl
endif

define LOGROTATE_INSTALL_TARGET_CONF
	$(INSTALL) -m 0644 package/logrotate/logrotate.conf $(TARGET_DIR)/etc/logrotate.conf
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/logrotate.d
endef
LOGROTATE_POST_INSTALL_TARGET_HOOKS += LOGROTATE_INSTALL_TARGET_CONF

$(eval $(autotools-package))
