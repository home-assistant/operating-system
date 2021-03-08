################################################################################
#
# gkrellm
#
################################################################################

GKRELLM_VERSION = 2.3.11
GKRELLM_SITE = http://gkrellm.srcbox.net/releases
GKRELLM_SOURCE = gkrellm-$(GKRELLM_VERSION).tar.bz2
GKRELLM_LICENSE = GPL-3.0+
GKRELLM_LICENSE_FILES = COPYING COPYRIGHT
GKRELLM_DEPENDENCIES = host-pkgconf libglib2 $(TARGET_NLS_DEPENDENCIES)
GKRELLM_BUILD_OPTS = \
	STRIP="" \
	SYS_LIBS=$(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_LM_SENSORS),y)
GKRELLM_DEPENDENCIES += lm-sensors
else
GKRELLM_BUILD_OPTS += without-libsensors=yes
endif

ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
GKRELLM_BUILD_OPTS += enable_nls=1
else
GKRELLM_BUILD_OPTS += enable_nls=0
endif

ifeq ($(BR2_PACKAGE_GKRELLM_SERVER)$(BR2_PACKAGE_GKRELLM_CLIENT),yy)
GKRELLM_BUILD_DIR = $(@D)
else ifeq ($(BR2_PACKAGE_GKRELLM_SERVER),y)
GKRELLM_BUILD_DIR = $(@D)/server
else
GKRELLM_BUILD_DIR = $(@D)/src
endif

ifeq ($(BR2_PACKAGE_GKRELLM_CLIENT),y)
GKRELLM_DEPENDENCIES += libgtk2 xlib_libSM
GKRELLM_BUILD_OPTS += X11_LIBS="-lX11 -lSM -lICE"
GKRELLM_LICENSE += GPL (base64.c), Public Domain (md5.h, md5c.c)
endif

define GKRELLM_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) \
		-C $(GKRELLM_BUILD_DIR) $(GKRELLM_BUILD_OPTS)
endef

define GKRELLM_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) \
		-C $(GKRELLM_BUILD_DIR) $(GKRELLM_BUILD_OPTS) \
		INSTALLROOT=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
