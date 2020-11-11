################################################################################
#
# libwpe
#
################################################################################

LIBWPE_VERSION = 1.8.0
LIBWPE_SITE = https://wpewebkit.org/releases
LIBWPE_SOURCE = libwpe-$(LIBWPE_VERSION).tar.xz
LIBWPE_INSTALL_STAGING = YES
LIBWPE_LICENSE = BSD-2-Clause
LIBWPE_LICENSE_FILES = COPYING
LIBWPE_DEPENDENCIES = libegl libxkbcommon

LIBWPE_CFLAGS = $(TARGET_CFLAGS)
LIBWPE_CXXFLAGS = $(TARGET_CXXFLAGS)

# Workaround for https://github.com/raspberrypi/userland/issues/316
ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
LIBWPE_CFLAGS += -D_GNU_SOURCE
LIBWPE_CXXFLAGS += -D_GNU_SOURCE
endif

$(eval $(meson-package))
