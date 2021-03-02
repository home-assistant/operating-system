################################################################################
#
# igd2-for-linux
#
################################################################################

IGD2_FOR_LINUX_VERSION = 2.1
IGD2_FOR_LINUX_SITE = \
	$(call github,Orange-OpenSource,igd2-for-linux,v$(IGD2_FOR_LINUX_VERSION))

IGD2_FOR_LINUX_LICENSE = GPL-2.0, BSD-3-Clause
IGD2_FOR_LINUX_LICENSE_FILES = linuxigd2/doc/LICENSE linuxigd2/src/threadutil/COPYING

IGD2_FOR_LINUX_DEPENDENCIES = libupnp
# From git
IGD2_FOR_LINUX_AUTORECONF = YES
IGD2_FOR_LINUX_SUBDIR = linuxigd2

define IGD2_FOR_LINUX_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/igd2-for-linux/S99upnpd \
		$(TARGET_DIR)/etc/init.d/S99upnpd
endef

define IGD2_FOR_LINUX_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/igd2-for-linux/upnpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/upnpd.service
endef

$(eval $(autotools-package))
