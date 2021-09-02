################################################################################
#
# htop
#
################################################################################

# This commit hash corresponds to version 3.0.5.
# htop sources were moved from bintray to github and the sources tar archive
# was also changed (the build process requires `HTOP_AUTORECONF = YES` now). We
# use commit hash instead of git tag here to avoid breaking existing source
# caches
HTOP_VERSION = ce6d60e7def146c13d0b8bca4642e7401a0a8995
HTOP_SITE = $(call github,htop-dev,htop,$(HTOP_VERSION))
HTOP_DEPENDENCIES = ncurses
HTOP_AUTORECONF = YES
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
