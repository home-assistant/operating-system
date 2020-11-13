################################################################################
#
# open-lldp
#
################################################################################

OPEN_LLDP_VERSION = 1.1
OPEN_LLDP_SITE = $(call github,intel,openlldp,v$(OPEN_LLDP_VERSION))
OPEN_LLDP_DEPENDENCIES = readline libnl libconfig host-pkgconf
OPEN_LLDP_LICENSE = GPL-2.0
OPEN_LLDP_LICENSE_FILES = COPYING

# Fetching from git
OPEN_LLDP_AUTORECONF = YES

ifeq ($(BR2_INIT_SYSTEMD),y)
OPEN_LLDP_DEPENDENCIES += systemd
OPEN_LLDP_CONF_OPTS += --with-systemdsystemunitdir=/usr/lib/systemd/system
endif

$(eval $(autotools-package))
