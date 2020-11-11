################################################################################
#
# unclutter-xfixes
#
################################################################################

UNCLUTTER_XFIXES_VERSION = 1.5
UNCLUTTER_XFIXES_SITE = $(call github,Airblader,unclutter-xfixes,v$(UNCLUTTER_XFIXES_VERSION))
UNCLUTTER_XFIXES_LICENSE = MIT
UNCLUTTER_XFIXES_LICENSE_FILES = LICENSE
UNCLUTTER_XFIXES_DEPENDENCIES = libev xlib_libX11 xlib_libXfixes xlib_libXi host-pkgconf

define UNCLUTTER_XFIXES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) unclutter CC="$(TARGET_CC)"
endef

define UNCLUTTER_XFIXES_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/unclutter $(TARGET_DIR)/usr/bin/unclutter
endef

$(eval $(generic-package))
