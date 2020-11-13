################################################################################
#
# netcalc
#
################################################################################

NETCALC_VERSION = 2.1.6
NETCALC_SITE = https://github.com/troglobit/netcalc/releases/download/v$(NETCALC_VERSION)
NETCALC_LICENSE = BSD-3-Clause
NETCALC_LICENSE_FILES = LICENSE
NETCALC_CONF_OPTS = --disable-ipcalc-symlink

$(eval $(autotools-package))
