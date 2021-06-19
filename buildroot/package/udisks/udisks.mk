################################################################################
#
# udisks
#
################################################################################

UDISKS_VERSION = 1.0.5
UDISKS_SITE = http://hal.freedesktop.org/releases
UDISKS_LICENSE = GPL-2.0+
UDISKS_LICENSE_FILES = COPYING
UDISKS_CPE_ID_VENDOR = freedesktop
# For 0002-Fix-systemd-service-file.patch
UDISKS_AUTORECONF = YES

UDISKS_DEPENDENCIES = \
	host-pkgconf \
	dbus \
	dbus-glib \
	libatasmart \
	libgudev \
	lvm2 \
	parted \
	polkit \
	sg3_utils \
	udev

UDISKS_CONF_OPTS = --disable-remote-access --disable-man-pages

ifeq ($(BR2_PACKAGE_UDISKS_LVM2),y)
UDISKS_CONF_OPTS += --enable-lvm2
endif

$(eval $(autotools-package))
