################################################################################
#
# watchdog
#
################################################################################

WATCHDOG_VERSION = 5.16
WATCHDOG_SITE = http://downloads.sourceforge.net/sourceforge/watchdog
WATCHDOG_LICENSE = GPL-2.0+
WATCHDOG_LICENSE_FILES = COPYING
# By default installs binaries in /usr/sbin/, but we want them in
# /sbin/ so that they fall at the same place as Busybox counterparts
WATCHDOG_CONF_OPTS = --sbindir=/sbin

$(eval $(autotools-package))
