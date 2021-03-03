################################################################################
#
# htop
#
################################################################################

HTOP_VERSION = 3.0.5
HTOP_SITE = https://dl.bintray.com/htop/source
HTOP_DEPENDENCIES = ncurses
# Prevent htop build system from searching the host paths
HTOP_CONF_ENV = HTOP_NCURSES_CONFIG_SCRIPT=$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS)
HTOP_LICENSE = GPL-2.0
HTOP_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LM_SENSORS),y)
HTOP_CONF_OPTS += --with-sensors
HTOP_DEPENDENCIES += lm-sensors
else
HTOP_CONF_OPTS += --without-sensors
endif

ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
HTOP_CONF_OPTS += --enable-unicode
else
HTOP_CONF_OPTS += --disable-unicode
endif

$(eval $(autotools-package))
