################################################################################
#
# INIH
#
################################################################################

INIH_VERSION = 52
INIH_SITE = $(call github,benhoyt,inih,r$(INIH_VERSION))
INIH_INSTALL_STAGING = YES
INIH_LICENSE = BSD-3-Clause
INIH_LICENSE_FILES = LICENSE.txt
INIH_CONF_OPTS = -Ddistro_install=true

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
INIH_CONF_OPTS += -Dwith_INIReader=true
else
INIH_CONF_OPTS += -Dwith_INIReader=false
endif

$(eval $(meson-package))
