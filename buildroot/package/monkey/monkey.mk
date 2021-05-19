################################################################################
#
# monkey
#
################################################################################

MONKEY_VERSION = f54856ce250c4e25735434dc75717a4b7fbfc45b
MONKEY_SITE = $(call github,monkey,monkey,$(MONKEY_VERSION))
MONKEY_LICENSE = Apache-2.0
MONKEY_LICENSE_FILES = LICENSE

MONKEY_CONF_OPTS = \
	-DMK_PATH_WWW=/var/www \
	-DWITHOUT_HEADERS=ON

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
MONKEY_CONF_OPTS += -DMK_UCLIB=ON -DMK_BACKTRACE=OFF
endif

ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
MONKEY_CONF_OPTS += -DMK_MUSL=ON -DMK_BACKTRACE=OFF
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
MONKEY_CONF_OPTS += -DMK_DEBUG=ON
endif

ifeq ($(BR2_PACKAGE_MONKEY_SSL),y)
MONKEY_CONF_OPTS += -DMK_PLUGIN_TLS=ON -DMK_MBEDTLS_SHARED=ON
MONKEY_DEPENDENCIES += mbedtls
endif

$(eval $(cmake-package))
