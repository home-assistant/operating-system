#############################################################
#
# apparmor
#
#############################################################
APPARMOR_VERSION = v2.13
APPARMOR_SITE = git://git.launchpad.net/apparmor
APPARMOR_LICENSE = GPL-2
APPARMOR_LICENSE_FILES = LICENSE
APPARMOR_INSTALL_STAGING = YES

APPARMOR_CONF_OPTS = \
	--prefix=/usr

define APPARMOR_CONFIGURE_CMDS
	cd $(@D)/libraries/libapparmor && \
	PATH=$(BR_PATH) ./autogen.sh && \
	PATH=$(BR_PATH) ./configure $(APPARMOR_CONF_OPTS)
endef

define APPARMOR_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/libraries/libapparmor
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/parser
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/profiles
endef

define APPARMOR_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/libraries/libapparmor DESTDIR=$(STAGING_DIR) PREFIX=/usr install
endef

define APPARMOR_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/parser DESTDIR=$(TARGET_DIR) PREFIX=/usr install
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/profiles DESTDIR=$(TARGET_DIR) PREFIX=/usr install
endef

$(eval $(generic-package))
