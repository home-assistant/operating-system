################################################################################
#
# libconfig
#
################################################################################

LIBCONFIG_VERSION = 1.7.3
LIBCONFIG_SITE = https://github.com/hyperrealm/libconfig/releases/download/v$(LIBCONFIG_VERSION)
LIBCONFIG_LICENSE = LGPL-2.1+
LIBCONFIG_LICENSE_FILES = COPYING.LIB
LIBCONFIG_INSTALL_STAGING = YES
LIBCONFIG_CONF_OPTS = --disable-examples --disable-tests

ifneq ($(BR2_INSTALL_LIBSTDCPP),y)
LIBCONFIG_CONF_OPTS += --disable-cxx
endif

$(eval $(autotools-package))
