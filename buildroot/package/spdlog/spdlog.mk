################################################################################
#
# spdlog
#
################################################################################

SPDLOG_VERSION = 1.8.2
SPDLOG_SITE = $(call github,gabime,spdlog,v$(SPDLOG_VERSION))
SPDLOG_LICENSE = MIT
SPDLOG_LICENSE_FILES = LICENSE
SPDLOG_INSTALL_STAGING = YES
SPDLOG_DEPENDENCIES = fmt
SPDLOG_CONF_OPTS += \
	-DSPDLOG_BUILD_TESTS=OFF \
	-DSPDLOG_BUILD_EXAMPLE=OFF \
	-DSPDLOG_BUILD_BENCH=OFF \
	-DSPDLOG_FMT_EXTERNAL=ON

ifeq ($(BR2_STATIC_LIBS),y)
SPDLOG_CONF_OPTS += -DSPDLOG_BUILD_SHARED=OFF
else
SPDLOG_CONF_OPTS += -DSPDLOG_BUILD_SHARED=ON
endif

$(eval $(cmake-package))
