#############################################################
#
# libapparmor
#
#############################################################
LIBAPPARMOR_VERSION = v2.13.4
LIBAPPARMOR_SITE = git://git.launchpad.net/apparmor
LIBAPPARMOR_LICENSE = GPL-2
LIBAPPARMOR_LICENSE_FILES = LICENSE
LIBAPPARMOR_INSTALL_STAGING = YES
LIBAPPARMOR_INSTALL_TARGET = NO
LIBAPPARMOR_DEPENDENCIES = host-flex
LIBAPPARMOR_SUBDIR = libraries/libapparmor
LIBAPPARMOR_CONF_ENV = ac_cv_func_reallocarray=no
LIBAPPARMOR_AUTORECONF = YES
LIBAPPARMOR_CONF_OPTS = --enable-static

$(eval $(autotools-package))
