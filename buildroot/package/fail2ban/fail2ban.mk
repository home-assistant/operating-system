################################################################################
#
# fail2ban
#
################################################################################

FAIL2BAN_VERSION = 0.11.2
FAIL2BAN_SITE = $(call github,fail2ban,fail2ban,$(FAIL2BAN_VERSION))
FAIL2BAN_LICENSE = GPL-2.0+
FAIL2BAN_LICENSE_FILES = COPYING
FAIL2BAN_CPE_ID_VENDOR = fail2ban
FAIL2BAN_SETUP_TYPE = distutils

# 0001-fixed-possible-RCE-vulnerability-unset-escape-variable.patch
FAIL2BAN_IGNORE_CVES += CVE-2021-32749

ifeq ($(BR2_PACKAGE_PYTHON3),y)
define FAIL2BAN_PYTHON_2TO3
	$(HOST_DIR)/bin/2to3 --write --nobackups --no-diffs $(@D)/bin/* $(@D)/fail2ban
endef
FAIL2BAN_DEPENDENCIES += host-python3
# We can't use _POST_PATCH_HOOKS because dependencies are not guaranteed
# to build and install before _POST_PATCH_HOOKS run.
FAIL2BAN_PRE_CONFIGURE_HOOKS += FAIL2BAN_PYTHON_2TO3
endif

define FAIL2BAN_FIX_DEFAULT_CONFIG
	$(SED) '/^socket/c\socket = /run/fail2ban.sock' $(TARGET_DIR)/etc/fail2ban/fail2ban.conf
	$(SED) '/^pidfile/c\pidfile = /run/fail2ban.pid' $(TARGET_DIR)/etc/fail2ban/fail2ban.conf
	$(SED) '/^dbfile/c\dbfile = None' $(TARGET_DIR)/etc/fail2ban/fail2ban.conf
endef
FAIL2BAN_POST_INSTALL_TARGET_HOOKS += FAIL2BAN_FIX_DEFAULT_CONFIG

# fail2ban-python points to host python
define FAIL2BAN_FIX_FAIL2BAN_PYTHON_SYMLINK
	ln -snf $(if $(BR2_PACKAGE_PYTHON),python,python3) \
		$(TARGET_DIR)/usr/bin/fail2ban-python
endef
FAIL2BAN_POST_INSTALL_TARGET_HOOKS += FAIL2BAN_FIX_FAIL2BAN_PYTHON_SYMLINK

define FAIL2BAN_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/fail2ban/S60fail2ban \
		$(TARGET_DIR)/etc/init.d/S60fail2ban
endef

define FAIL2BAN_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/files/fail2ban.service.in \
		$(TARGET_DIR)/usr/lib/systemd/system/fail2ban.service
	$(SED) 's,@BINDIR@,/usr/bin,g' $(TARGET_DIR)/usr/lib/systemd/system/fail2ban.service
	$(SED) '/^PIDFile/c\PIDFile=/run/fail2ban.pid' $(TARGET_DIR)/usr/lib/systemd/system/fail2ban.service
endef

$(eval $(python-package))
