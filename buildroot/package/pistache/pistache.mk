################################################################################
#
# pistache
#
################################################################################

PISTACHE_VERSION = f2f5a50fbfb5b8ef6cf1d3d2a9d442a8270e375d
PISTACHE_SITE = $(call github,oktal,pistache,$(PISTACHE_VERSION))
PISTACHE_LICENSE = Apache-2.0
PISTACHE_LICENSE_FILES = LICENSE

PISTACHE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_OPENSSL),y)
PISTACHE_DEPENDENCIES += openssl
PISTACHE_CONF_OPTS += -DPISTACHE_USE_SSL=ON
else
PISTACHE_CONF_OPTS += -DPISTACHE_USE_SSL=OFF
endif

$(eval $(cmake-package))
