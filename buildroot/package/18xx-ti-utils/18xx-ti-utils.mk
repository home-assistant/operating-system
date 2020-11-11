################################################################################
#
# 18xx-ti-utils
#
################################################################################

18XX_TI_UTILS_VERSION = 8.8
18XX_TI_UTILS_SITE = https://git.ti.com/cgit/wilink8-wlan/18xx-ti-utils/snapshot
18XX_TI_UTILS_SOURCE = 18xx-ti-utils-R$(18XX_TI_UTILS_VERSION).tar.xz
18XX_TI_UTILS_DEPENDENCIES = libnl
18XX_TI_UTILS_LICENSE = BSD-3-Clause
18XX_TI_UTILS_LICENSE_FILES = COPYING

18XX_TI_UTILS_CFLAGS = -I$(STAGING_DIR)/usr/include/libnl3 -DCONFIG_LIBNL32

ifeq ($(BR2_STATIC_LIBS),y)
18XX_TI_UTILS_BUILD_TARGET = static
endif

define 18XX_TI_UTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) CROSS_COMPILE=$(TARGET_CROSS) \
		NFSROOT="$(STAGING_DIR)" NLVER=3 $(MAKE) -C $(@D) \
		CFLAGS="$(TARGET_CFLAGS) $(18XX_TI_UTILS_CFLAGS)" \
		$(18XX_TI_UTILS_BUILD_TARGET)

	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/wlconf \
		$(HOST_CONFIGURE_OPTS)
endef

define 18XX_TI_UTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/calibrator $(TARGET_DIR)/usr/bin/calibrator
	$(INSTALL) -m 0755 $(@D)/wlconf/wlconf $(HOST_DIR)/bin/wlconf
endef

$(eval $(generic-package))
