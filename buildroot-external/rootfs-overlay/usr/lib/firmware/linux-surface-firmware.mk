LINUX_SURFACE_FW_VERSION = 1
LINUX_SURFACE_FW_SITE = https://github.com/linux-surface/surface-aggregator-module/raw/main/firmware
LINUX_SURFACE_FW_SITE_METHOD = git
LINUX_SURFACE_FW_INSTALL_TARGET = YES

define LINUX_SURFACE_FW_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0644 $(@D)/* \
        $(TARGET_DIR)/lib/firmware/
endef

$(eval $(generic-package))
