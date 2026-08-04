################################################################################
#
# Optional device tree overlays for Home Assistant Yellow, enabled by the
# user through dtoverlay= entries in config.txt.
#
################################################################################

YELLOW_OVERLAYS_VERSION = 1.0.0
YELLOW_OVERLAYS_LICENSE = Apache License 2.0
YELLOW_OVERLAYS_LICENSE_FILES = $(BR2_EXTERNAL_HAOS_PATH)/../LICENSE
YELLOW_OVERLAYS_SITE = $(BR2_EXTERNAL_HAOS_PATH)/package/yellow-overlays
YELLOW_OVERLAYS_SITE_METHOD = local
YELLOW_OVERLAYS_DEPENDENCIES = host-dtc

define YELLOW_OVERLAYS_BUILD_CMDS
	$(foreach dts,$(wildcard $(YELLOW_OVERLAYS_PKGDIR)/dts/*.dts), \
		$(HOST_DIR)/bin/dtc -@ -I dts -O dtb \
			-o $(@D)/$(notdir $(basename $(dts))).dtbo $(dts)$(sep))
endef

define YELLOW_OVERLAYS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 -t $(BINARIES_DIR) $(@D)/*.dtbo
endef

$(eval $(generic-package))
