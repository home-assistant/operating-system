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
	
	$(MAKE) -C libraries/libapparmor
	$(MAKE) -C parser
	$(MAKE) -C profile
endif

define APPARMOR_STAGING_CMDS
	$(MAKE) -C DESTDIR=$(STAGING_DIR) libraries/libapparmor install
endif

define APPARMOR_TARGET_CMDS
	$(MAKE) -C DESTDIR=$(TARGET_DIR) parser install
	$(MAKE) -C DESTDIR=$(TARGET_DIR) profile install
endif

$(eval $(generic-package))
