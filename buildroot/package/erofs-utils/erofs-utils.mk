################################################################################
#
# erofs-utils
#
################################################################################

EROFS_UTILS_VERSION = 1.1
EROFS_UTILS_SITE = https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot
EROFS_UTILS_LICENSE = GPL-2.0+
EROFS_UTILS_LICENSE_FILES = COPYING

# From a git tree: no generated autotools files
EROFS_UTILS_AUTORECONF = YES

EROFS_UTILS_DEPENDENCIES = host-pkgconf util-linux

ifeq ($(BR2_PACKAGE_EROFS_UTILS_LZ4),y)
EROFS_UTILS_DEPENDENCIES += lz4
EROFS_UTILS_CONF_OPTS += --enable-lz4
else
EROFS_UTILS_CONF_OPTS += --disable-lz4
endif

HOST_EROFS_UTILS_DEPENDENCIES = host-pkgconf host-util-linux host-lz4
HOST_EROFS_UTILS_CONF_OPTS += --enable-lz4

$(eval $(autotools-package))
$(eval $(host-autotools-package))
