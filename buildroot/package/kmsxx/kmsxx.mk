################################################################################
#
# kmsxx
#
################################################################################

KMSXX_VERSION = 548905611c130ea9d31929a0caf7a198d8bac462
KMSXX_SITE = $(call github,tomba,kmsxx,$(KMSXX_VERSION))
KMSXX_LICENSE = MPL-2.0
KMSXX_LICENSE_FILES = LICENSE
KMSXX_INSTALL_STAGING = YES
KMSXX_DEPENDENCIES = fmt libdrm host-pkgconf
KMSXX_CONF_OPTS = \
	-Dkmscube=false \
	-Dpykms=disabled \
	-Domap=disabled \
	-Duse-system-fmt=true \
	-Duse-system-pybind11=true

ifeq ($(BR2_STATIC_LIBS),y)
KMSXX_CONF_OPTS += -Dstatic-libc=true
else
KMSXX_CONF_OPTS += -Dstatic-libc=false
endif

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
KMSXX_CXXFLAGS += $(TARGET_CXXFLAGS) -O0
endif

ifeq ($(BR2_PACKAGE_KMSXX_INSTALL_TESTS),y)
KMSXX_CONF_OPTS += -Dutils=true
# extra handling for some utils not installed by default
KMSXX_EXTRA_UTILS = kmsview kmscapture omap-wbcap omap-wbm2m
ifeq ($(BR2_PACKAGE_LIBEVDEV),y)
KMSXX_DEPENDENCIES += libevdev
KMSXX_EXTRA_UTILS += kmstouch
endif
define KMSXX_INSTALL_EXTRA_UTILS
	$(foreach t,$(KMSXX_EXTRA_UTILS),\
		$(INSTALL) -D -m 0755 $(@D)/build/utils/$(t) \
			$(TARGET_DIR)/usr/bin/$(t)
	)
endef
KMSXX_POST_INSTALL_TARGET_HOOKS += KMSXX_INSTALL_EXTRA_UTILS
else
KMSXX_CONF_OPTS += -Dutils=false
endif

$(eval $(meson-package))
