################################################################################
#
# netopeer2
#
################################################################################

NETOPEER2_VERSION = 1.1.53
NETOPEER2_SITE = $(call github,CESNET,Netopeer2,v$(NETOPEER2_VERSION))
NETOPEER2_DL_SUBDIR = netopeer2
NETOPEER2_LICENSE = BSD-3-Clause
NETOPEER2_LICENSE_FILES = LICENSE
NETOPEER2_DEPENDENCIES = libnetconf2 libyang sysrepo host-sysrepo

NETOPEER2_CONF_OPTS = -DBUILD_CLI=$(if $(BR2_PACKAGE_NETOPEER2_CLI),ON,OFF)

# Set a build specific SYSREPO_SHM_PREFIX to ensure we can safely delete the
# files. This also ensures that concurrent parallel builds will not be
# affected mutualy.
NETOPEER2_SYSREPO_SHM_PREFIX = sr_buildroot$(subst /,_,$(CONFIG_DIR))_netopeer2

NETOPEER2_MAKE_ENV = \
	SYSREPOCTL_EXECUTABLE=$(HOST_DIR)/bin/sysrepoctl \
	SYSREPO_SHM_PREFIX=$(NETOPEER2_SYSREPO_SHM_PREFIX)

define NETOPEER2_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/netopeer2/S52netopeer2 \
		$(TARGET_DIR)/etc/init.d/S52netopeer2
endef

# The host sysrepo used to install the netopeer2 modules will leave
# its shared memory files lingering about. Clean up in its stead...
# We need to clean up both before and after installation, to catch
# the case of a previous build that failed before we run that hook.
define NETOPEER2_CLEANUP
	rm -f /dev/shm/$(NETOPEER2_SYSREPO_SHM_PREFIX)*
endef
NETOPEER2_PRE_INSTALL_TARGET_HOOKS += NETOPEER2_CLEANUP
NETOPEER2_POST_INSTALL_TARGET_HOOKS += NETOPEER2_CLEANUP

$(eval $(cmake-package))
