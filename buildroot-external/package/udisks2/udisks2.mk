################################################################################
#
# udisks2
#
################################################################################

UDISKS2_VERSION = 2.10.1
UDISKS2_SITE = https://github.com/storaged-project/udisks/releases/download/udisks-$(UDISKS2_VERSION)
UDISKS2_SOURCE = udisks-$(UDISKS2_VERSION).tar.bz2
UDISKS2_LICENSE = GPL-2.0+
UDISKS2_LICENSE_FILES = COPYING
# For 0002-Make-polkit-dependency-optional.patch
# Running autoreconf when GObject Introspection is not selected
# requires 0003-Avoid-autoreconf-error-if-introspection-macros-are-n.patch
UDISKS2_AUTORECONF = YES

UDISKS2_DEPENDENCIES = \
	host-pkgconf \
	dbus \
	dbus-glib \
	libatasmart \
	libblockdev \
	libgudev \
	lvm2 \
	parted \
	udev

UDISKS2_CONF_OPTS = --disable-polkit --disable-man --disable-libsystemd-login

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
UDISKS2_CONF_OPTS += --enable-introspection
UDISKS2_DEPENDENCIES += gobject-introspection
else
UDISKS2_CONF_OPTS += --disable-introspection
endif

ifeq ($(BR2_PACKAGE_UDISKS2_LVM2),y)
UDISKS2_CONF_OPTS += --enable-lvm2
endif

$(eval $(autotools-package))
