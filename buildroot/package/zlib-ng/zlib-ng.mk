################################################################################
#
# zlib-ng
#
################################################################################

ZLIB_NG_VERSION = 1.9.9-b1
ZLIB_NG_SITE = $(call github,zlib-ng,zlib-ng,$(ZLIB_NG_VERSION))
ZLIB_NG_LICENSE = Zlib
ZLIB_NG_LICENSE_FILES = LICENSE.md
ZLIB_NG_INSTALL_STAGING = YES
ZLIB_NG_PROVIDES = zlib

# Build with zlib compatible API, gzFile support and optimizations on
ZLIB_NG_CONF_OPTS += \
	-DWITH_GZFILEOP=1 \
	-DWITH_OPTIM=1 \
	-DZLIB_COMPAT=1 \
	-DZLIB_ENABLE_TESTS=OFF

# Enable NEON and ACLE on ARM
ifeq ($(BR2_arm),y)
ZLIB_NG_CONF_OPTS += -DWITH_ACLE=1 -DWITH_NEON=1
endif

$(eval $(cmake-package))
