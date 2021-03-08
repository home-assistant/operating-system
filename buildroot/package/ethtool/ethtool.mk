################################################################################
#
# ethtool
#
################################################################################

ETHTOOL_VERSION = 5.10
ETHTOOL_SOURCE = ethtool-$(ETHTOOL_VERSION).tar.xz
ETHTOOL_SITE = $(BR2_KERNEL_MIRROR)/software/network/ethtool
ETHTOOL_LICENSE = GPL-2.0
ETHTOOL_LICENSE_FILES = LICENSE COPYING
ETHTOOL_CPE_ID_VENDOR = kernel
ETHTOOL_CONF_OPTS = \
	$(if $(BR2_PACKAGE_ETHTOOL_PRETTY_PRINT),--enable-pretty-dump,--disable-pretty-dump)

ifeq ($(BR2_PACKAGE_LIBMNL),y)
ETHTOOL_DEPENDENCIES += host-pkgconf libmnl
ETHTOOL_CONF_OPTS += --enable-netlink
else
ETHTOOL_CONF_OPTS += --disable-netlink
endif

$(eval $(autotools-package))
