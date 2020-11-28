################################################################################
#
# multipath-tools
#
################################################################################

MULTIPATH_TOOLS_VERSION = 0.8.4
MULTIPATH_TOOLS_SITE = $(call github,openSUSE,multipath-tools,$(MULTIPATH_TOOLS_VERSION))
MULTIPATH_TOOLS_LICENSE = LGPL-2.0
MULTIPATH_TOOLS_LICENSE_FILES = COPYING
MULTIPATH_TOOLS_DEPENDENCIES = lvm2 json-c readline udev liburcu libaio host-pkgconf
MULTIPATH_TOOLS_MAKE_OPTS = LIB="lib" RUN="run" OPTFLAGS="" STACKPROT=""

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
MULTIPATH_TOOLS_DEPENDENCIES += systemd
MULTIPATH_TOOLS_MAKE_OPTS += ENABLE_SYSTEMD=1
endif

define MULTIPATH_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(MULTIPATH_TOOLS_MAKE_OPTS)
endef

define MULTIPATH_TOOLS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) install \
		$(MULTIPATH_TOOLS_MAKE_OPTS) DESTDIR="$(TARGET_DIR)"
endef

define MULTIPATH_TOOLS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/multipath-tools/S60multipathd \
		$(TARGET_DIR)/etc/init.d/S60multipathd
endef

$(eval $(generic-package))
