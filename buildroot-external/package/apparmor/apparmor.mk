#############################################################
#
# apparmor
#
#############################################################
APPARMOR_VERSION = v2.13.4
APPARMOR_SITE = git://git.launchpad.net/apparmor
APPARMOR_LICENSE = GPL-2
APPARMOR_LICENSE_FILES = LICENSE
APPARMOR_DEPENDENCIES = libapparmor

define APPARMOR_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) PATH=$(BR_PATH) $(MAKE) -C $(@D)/parser USE_SYSTEM=1 YACC=bison LEX=flex 
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/profiles
endef

define APPARMOR_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/parser DESTDIR=$(TARGET_DIR) USE_SYSTEM=1 PREFIX=/usr install
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/profiles DESTDIR=$(TARGET_DIR) PREFIX=/usr install

	rm -rf $(TARGET_DIR)/usr/lib/apparmor
endef

$(eval $(generic-package))
