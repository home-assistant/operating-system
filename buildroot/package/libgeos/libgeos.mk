################################################################################
#
# libgeos
#
################################################################################

LIBGEOS_VERSION = 3.9.0
LIBGEOS_SITE = http://download.osgeo.org/geos
LIBGEOS_SOURCE = geos-$(LIBGEOS_VERSION).tar.bz2
LIBGEOS_LICENSE = LGPL-2.1
LIBGEOS_LICENSE_FILES = COPYING
LIBGEOS_INSTALL_STAGING = YES
LIBGEOS_CONFIG_SCRIPTS = geos-config
LIBGEOS_CONF_OPTS = -DBUILD_BENCHMARKS=OFF

LIBGEOS_CXXFLAGS = $(TARGET_CXXCFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
LIBGEOS_CXXFLAGS += -O0
endif

ifeq ($(BR2_arm)$(BR2_armeb),y)
LIBGEOS_CONF_OPTS += -DDISABLE_GEOS_INLINE=ON
endif

LIBGEOS_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(LIBGEOS_CXXFLAGS)"

$(eval $(cmake-package))
