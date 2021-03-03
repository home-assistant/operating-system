################################################################################
#
# bustle
#
################################################################################

BUSTLE_VERSION = 0.8.0
BUSTLE_SITE = https://hackage.haskell.org/package/bustle-$(BUSTLE_VERSION)
BUSTLE_LICENSE = LGPL-2.1+
BUSTLE_LICENSE_FILES = LICENSE
BUSTLE_DEPENDENCIES = libglib2 libpcap host-pkgconf
BUSTLE_MAKE_OPTS = PCAP_CONFIG=$(STAGING_DIR)/usr/bin/pcap-config

define BUSTLE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(BUSTLE_MAKE_OPTS) -C $(@D) dist/build/bustle-pcap
endef

define BUSTLE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/dist/build/bustle-pcap \
		$(TARGET_DIR)/usr/bin/bustle-pcap
endef

$(eval $(generic-package))
