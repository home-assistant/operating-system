################################################################################
#
# abootimg
#
################################################################################

ABOOTIMG_VERSION = 7e127fee6a3981f6b0a50ce9910267cd501e09d4
ABOOTIMG_SITE = $(call github,ggrandou,abootimg,$(ABOOTIMG_VERSION))
ABOOTIMG_LICENSE = GPL-2.0+
ABOOTIMG_LICENSE_FILES = LICENSE

# depends on libblkid from util-linux
ABOOTIMG_DEPENDENCIES = util-linux
HOST_ABOOTIMG_DEPENDENCIES = host-util-linux

define ABOOTIMG_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define ABOOTIMG_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/abootimg $(TARGET_DIR)/usr/bin/abootimg
endef

define HOST_ABOOTIMG_BUILD_CMDS
	$(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D)
endef

define HOST_ABOOTIMG_INSTALL_CMDS
	$(INSTALL) -m 0755 $(@D)/abootimg $(HOST_DIR)/usr/bin/abootimg
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
