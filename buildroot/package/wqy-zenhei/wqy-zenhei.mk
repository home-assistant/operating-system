################################################################################
#
# wqy-zenhei
#
################################################################################

WQY_ZENHEI_VERSION = 0.9.45
WQY_ZENHEI_SITE = https://downloads.sourceforge.net/project/wqy/wqy-zenhei/$(WQY_ZENHEI_VERSION)%20%28Fighting-state%20RC1%29
WQY_ZENHEI_LICENSE =  GPL-2.0-with-font-exception
WQY_ZENHEI_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
define WQY_ZENHEI_FONTCONFIG_CONF_INSTALL_CMDS
	$(INSTALL) -D -m 0644 $(@D)/43-wqy-zenhei-sharp.conf \
	    $(TARGET_DIR)/usr/share/fontconfig/conf.avail/43-wqy-zenhei-sharp.conf
	$(INSTALL) -D -m 0644 $(@D)/44-wqy-zenhei.conf \
	    $(TARGET_DIR)/usr/share/fontconfig/conf.avail/44-wqy-zenhei.conf
endef
endif

define WQY_ZENHEI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/wqy-zenhei.ttc \
		$(TARGET_DIR)/usr/share/fonts/wqy-zenhei/wqy-zenhei.ttc
	$(WQY_ZENHEI_FONTCONFIG_CONF_INSTALL_CMDS)
endef

$(eval $(generic-package))
