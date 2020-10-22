################################################################################
#
# ipmitool
#
################################################################################

IPMITOOL_VERSION = 1.8.18
IPMITOOL_SOURCE = ipmitool-$(IPMITOOL_VERSION).tar.bz2
IPMITOOL_SITE = http://downloads.sourceforge.net/project/ipmitool/ipmitool/$(IPMITOOL_VERSION)
IPMITOOL_LICENSE = BSD-3-Clause
IPMITOOL_LICENSE_FILES = COPYING

# 0008-fru-Fix-buffer-overflow-vulnerabilities.patch
# 0009-fru-Fix-buffer-overflow-in-ipmi_spd_print_fru.patch
# 0010-session-Fix-buffer-overflow-in-ipmi_get_session_info.patch
# 0011-channel-Fix-buffer-overflow.patch
# 0012-lanp-Fix-buffer-overflows-in-get_lan_param_select.patch
# 0013-fru-sdr-Fix-id_string-buffer-overflows.patch
IPMITOOL_IGNORE_CVES += CVE-2020-5208

ifeq ($(BR2_PACKAGE_IPMITOOL_LANPLUS),y)
IPMITOOL_DEPENDENCIES += openssl
IPMITOOL_CONF_OPTS += --enable-intf-lanplus
else
IPMITOOL_CONF_OPTS += --disable-intf-lanplus
endif

ifeq ($(BR2_PACKAGE_IPMITOOL_USB),y)
IPMITOOL_CONF_OPTS += --enable-intf-usb
else
IPMITOOL_CONF_OPTS += --disable-intf-usb
endif

ifeq ($(BR2_PACKAGE_IPMITOOL_IPMISHELL),y)
IPMITOOL_DEPENDENCIES += ncurses readline
IPMITOOL_CONF_OPTS += --enable-ipmishell
else
IPMITOOL_CONF_OPTS += --disable-ipmishell
endif

ifeq ($(BR2_PACKAGE_IPMITOOL_IPMIEVD),)
define IPMITOOL_REMOVE_IPMIEVD
	$(RM) -f $(TARGET_DIR)/usr/sbin/ipmievd
endef
IPMITOOL_POST_INSTALL_TARGET_HOOKS += IPMITOOL_REMOVE_IPMIEVD
endif

$(eval $(autotools-package))
