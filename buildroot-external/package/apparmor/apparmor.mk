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

define APPARMOR_BUILD_CMDS
	cd $(@D)/libraries/libapparmor && \
	./autogen.sh && \
	./configure $(APPARMOR_CONF_OPTS)
	
	$(MAKE) $(STAGING_CONFIGURE_OPTS) -C $(@D)/libraries/libapparmor
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/parser
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/profiles
endef

define APPARMOR_INSTALL_STAGING_CMDS
	$(STAGING_MAKE_ENV) $(MAKE) -C $(@D)/libraries/libapparmor DESTDIR=$(STAGING_DIR) install
endef

define APPARMOR_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/parser DESTDIR=$(TARGET_DIR) install
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/profiles DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
