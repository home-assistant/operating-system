################################################################################
#
# rtk-hciattach
#
################################################################################

RTK_HCIATTACH_VERSION = 1.0.0
RTK_HCIATTACH_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/rtk-hciattach/src
RTK_HCIATTACH_SITE_METHOD = local

define RTK_HCIATTACH_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) make -C $(@D)
endef

define RTK_HCIATTACH_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/rtk_hciattach $(TARGET_DIR)/usr/bin/rtk_hciattach
endef

$(eval $(generic-package))
