################################################################################
#
# ipcalc
#
################################################################################

IPCALC_VERSION = 1.0.0
IPCALC_SITE = $(call gitlab,ipcalc,ipcalc,$(IPCALC_VERSION))
IPCALC_SOURCE = ipcalc-$(IPCALC_VERSION).tar.bz2
IPCALC_LICENSE = GPL-2.0+
IPCALC_LICENSE_FILES = COPYING

IPCALC_CONF_OPTS = \
	-Duse_maxminddb=disabled \
	-Duse_geoip=disabled

$(eval $(meson-package))
