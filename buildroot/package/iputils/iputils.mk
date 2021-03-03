################################################################################
#
# iputils
#
################################################################################

# The original upstream was forked to the github repository in 2014 to
# pull fixes from other distribution and centralize the changes after
# the upstream seemed to have gone dormant.  The fork contains the
# latest changes including musl support, removing a libsysfs dependency
# and IPv6 updates.
# http://www.spinics.net/lists/netdev/msg279881.html

IPUTILS_VERSION = 20210202
IPUTILS_SITE = $(call github,iputils,iputils,$(IPUTILS_VERSION))
IPUTILS_LICENSE = GPL-2.0+, BSD-3-Clause
IPUTILS_LICENSE_FILES = LICENSE Documentation/LICENSE.BSD3 Documentation/LICENSE.GPL2
IPUTILS_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)

# Selectively build binaries
IPUTILS_CONF_OPTS += \
	-DBUILD_CLOCKDIFF=$(if $(BR2_PACKAGE_IPUTILS_CLOCKDIFF),true,false) \
	-DBUILD_RARPD=$(if $(BR2_PACKAGE_IPUTILS_RARPD),true,false) \
	-DBUILD_RDISC=$(if $(BR2_PACKAGE_IPUTILS_RDISC),true,false) \
	-DBUILD_RDISC_SERVER=$(if $(BR2_PACKAGE_IPUTILS_RDISC_SERVER),true,false) \
	-DBUILD_TRACEPATH=$(if $(BR2_PACKAGE_IPUTILS_TRACEPATH),true,false) \
	-DBUILD_TRACEROUTE6=$(if $(BR2_PACKAGE_IPUTILS_TRACEROUTE6),true,false) \
	-DBUILD_NINFOD=$(if $(BR2_PACKAGE_IPUTILS_NINFOD),true,false)

# Selectively select the appropriate SELinux refpolicy modules
IPUTILS_SELINUX_MODULES = \
	$(if $(BR2_PACKAGE_IPUTILS_ARPING),netutils) \
	$(if $(BR2_PACKAGE_IPUTILS_PING),netutils) \
	$(if $(BR2_PACKAGE_IPUTILS_TRACEPATH),netutils) \
	$(if $(BR2_PACKAGE_IPUTILS_TRACEROUTE6),netutils) \
	$(if $(BR2_PACKAGE_IPUTILS_RDISC),rdisc) \
	$(if $(BR2_PACKAGE_IPUTILS_TFTPD),tftp)

#
# arping
#
ifeq ($(BR2_PACKAGE_IPUTILS_ARPING),y)
IPUTILS_CONF_OPTS += -DBUILD_ARPING=true

# move some binaries to the same location as where Busybox installs
# the corresponding applets, so that we have a single version of the
# tools (from iputils)
define IPUTILS_MOVE_ARPING_BINARY
	mv $(TARGET_DIR)/usr/bin/arping $(TARGET_DIR)/usr/sbin/arping
endef
IPUTILS_POST_INSTALL_TARGET_HOOKS += IPUTILS_MOVE_ARPING_BINARY

else
IPUTILS_CONF_OPTS += -DBUILD_ARPING=false
endif

#
# ping
#
ifeq ($(BR2_PACKAGE_IPUTILS_PING),y)
IPUTILS_CONF_OPTS += -DBUILD_PING=true

# same reason to move the ping binary as for arping
ifeq ($(BR2_ROOTFS_MERGED_USR),)
define IPUTILS_MOVE_PING_BINARY
	mv $(TARGET_DIR)/usr/bin/ping $(TARGET_DIR)/bin/ping
endef
IPUTILS_POST_INSTALL_TARGET_HOOKS += IPUTILS_MOVE_PING_BINARY
endif

# upstream requires distros to create symlink
define IPUTILS_CREATE_PING6_SYMLINK
	ln -sf ping $(TARGET_DIR)/bin/ping6
endef
IPUTILS_POST_INSTALL_TARGET_HOOKS += IPUTILS_CREATE_PING6_SYMLINK

else
IPUTILS_CONF_OPTS += -DBUILD_PING=false
endif

#
# tftpd
#
ifeq ($(BR2_PACKAGE_IPUTILS_TFTPD),y)
IPUTILS_CONF_OPTS += -DBUILD_TFTPD=true

else
IPUTILS_CONF_OPTS += -DBUILD_TFTPD=false
endif

# Handle libraries
ifeq ($(BR2_PACKAGE_LIBCAP),y)
IPUTILS_CONF_OPTS += -DUSE_CAP=true
IPUTILS_DEPENDENCIES += libcap
else
IPUTILS_CONF_OPTS += -DUSE_CAP=false
endif

ifeq ($(BR2_PACKAGE_LIBIDN2),y)
IPUTILS_CONF_OPTS += -DUSE_IDN=true
IPUTILS_DEPENDENCIES += libidn2
else
IPUTILS_CONF_OPTS += -DUSE_IDN=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
IPUTILS_DEPENDENCIES += systemd
endif

ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
IPUTILS_CONF_OPTS += -DUSE_GETTEXT=true
else
IPUTILS_CONF_OPTS += -DUSE_GETTEXT=false
endif

# XSL Stylesheets for DocBook 5 not packaged for buildroot
IPUTILS_CONF_OPTS += -DBUILD_MANS=false -DBUILD_HTML_MANS=false

# handle permissions ourselves
IPUTILS_CONF_OPTS += -DNO_SETCAP_OR_SUID=true
ifeq ($(BR2_ROOTFS_DEVICE_TABLE_SUPPORTS_EXTENDED_ATTRIBUTES),y)
define IPUTILS_PERMISSIONS
	$(if $(BR2_PACKAGE_IPUTILS_ARPING),\
		/usr/sbin/arping      f 755 0 0 - - - - -,)
	$(if $(BR2_PACKAGE_IPUTILS_CLOCKDIFF),\
		/usr/bin/clockdiff    f 755 0 0 - - - - -
		|xattr cap_net_raw+p,)
	$(if $(BR2_PACKAGE_IPUTILS_PING),\
		/bin/ping             f 755 0 0 - - - - -
		|xattr cap_net_raw+p,)
	$(if $(BR2_PACKAGE_IPUTILS_TRACEROUTE6),\
		/usr/bin/traceroute6  f 755 0 0 - - - - -
		|xattr cap_net_raw+p,)
endef
else
define IPUTILS_PERMISSIONS
	$(if $(BR2_PACKAGE_IPUTILS_ARPING),\
		/usr/sbin/arping      f  755 0 0 - - - - -,)
	$(if $(BR2_PACKAGE_IPUTILS_CLOCKDIFF),\
		/usr/bin/clockdiff    f 4755 0 0 - - - - -,)
	$(if $(BR2_PACKAGE_IPUTILS_PING),\
		/bin/ping             f 4755 0 0 - - - - -,)
	$(if $(BR2_PACKAGE_IPUTILS_TRACEROUTE6),\
		/usr/bin/traceroute6  f 4755 0 0 - - - - -,)
endef
endif

$(eval $(meson-package))
