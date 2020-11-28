################################################################################
#
# babeltrace2
#
################################################################################

BABELTRACE2_SITE = https://www.efficios.com/files/babeltrace
BABELTRACE2_VERSION = 2.0.3
BABELTRACE2_SOURCE = babeltrace2-$(BABELTRACE2_VERSION).tar.bz2
BABELTRACE2_LICENSE = MIT, LGPL-2.1 (src/common/list.h), GPL-2.0 (test code)
BABELTRACE2_LICENSE_FILES = mit-license.txt lgpl-2.1.txt gpl-2.0.txt LICENSE
# We're patching configure.ac
BABELTRACE2_AUTORECONF = YES
BABELTRACE2_CONF_OPTS = --disable-man-pages
BABELTRACE2_DEPENDENCIES = libglib2 host-pkgconf
# The host-elfutils dependency is optional, but since we don't have
# options for host packages, just build support for it
# unconditionally.
HOST_BABELTRACE2_DEPENDENCIES = host-libglib2 host-pkgconf host-elfutils
HOST_BABELTRACE2_CONF_OPTS += --enable-debug-info

ifeq ($(BR2_PACKAGE_ELFUTILS),y)
BABELTRACE2_DEPENDENCIES += elfutils
BABELTRACE2_CONF_OPTS += --enable-debug-info
BABELTRACE2_CONF_ENV += bt_cv_lib_elfutils=yes
else
BABELTRACE2_CONF_OPTS += --disable-debug-info
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
