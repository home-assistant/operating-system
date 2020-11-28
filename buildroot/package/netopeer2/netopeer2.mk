################################################################################
#
# netopeer2
#
################################################################################

NETOPEER2_VERSION = 1.1.39
NETOPEER2_SITE = $(call github,CESNET,Netopeer2,v$(NETOPEER2_VERSION))
NETOPEER2_DL_SUBDIR = netopeer2
NETOPEER2_LICENSE = BSD-3-Clause
NETOPEER2_LICENSE_FILES = LICENSE
NETOPEER2_DEPENDENCIES = libnetconf2 libyang sysrepo

NETOPEER2_CONF_OPTS = -DBUILD_CLI=$(if $(BR2_PACKAGE_NETOPEER2_CLI),ON,OFF)

define NETOPEER2_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/netopeer2/S52netopeer2 \
		$(TARGET_DIR)/etc/init.d/S52netopeer2
endef

$(eval $(cmake-package))
