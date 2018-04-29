#############################################################
#
# apparmor
#
#############################################################
APPARMOR_VERSION_MAJOR = 2.13
APPARMOR_VERSION = $(APPARMOR_VERSION_MAJOR).0
APPARMOR_SITE    = https://launchpad.net/apparmor/$(APPARMOR_VERSION_MAJOR)/$(APPARMOR_VERSION)/+download
APPARMOR_LICENSE = GPL-2
APPARMOR_LICENSE_FILES = LICENSE
APPARMOR_INSTALL_STAGING = YES

APPARMOR_CONF_OPTS = \
	--prefix=/usr

define APPARMOR_BUILD_CMDS
	cd libraries/libapparmor && \
	./autogen.sh && \
	./configure $(APPARMOR_CONF_OPTS)
	
	$(MAKE) $(STAGING_CONFIGURE_OPTS) -C libraries/libapparmor
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C parser
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C profile
endif

define APPARMOR_INSTALL_STAGING_CMDS
	$(STAGING_MAKE_ENV) $(MAKE) -C DESTDIR=$(STAGING_DIR) libraries/libapparmor install
endif

define APPARMOR_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C DESTDIR=$(TARGET_DIR) parser install
	$(TARGET_MAKE_ENV) $(MAKE) -C DESTDIR=$(TARGET_DIR) profile install
endif

$(eval $(generic-package))
