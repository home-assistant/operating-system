################################################################################
#
# aumix
#
################################################################################

AUMIX_VERSION = 2.9.1
AUMIX_SOURCE = aumix-$(AUMIX_VERSION).tar.bz2
AUMIX_SITE = http://jpj.net/~trevor/aumix/releases
AUMIX_AUTORECONF = YES
AUMIX_GETTEXTIZE = YES
AUMIX_LICENSE = GPL-2.0+
AUMIX_LICENSE_FILES = COPYING

AUMIX_PATCH = \
	https://sources.debian.org/data/main/a/aumix/2.9.1-7/debian/patches/19_no-common.patch

AUMIX_CONF_OPTS = \
	--without-gtk \
	--without-gtk1 \
	--without-alsa \
	--without-gpm \
	--without-sysmouse

AUMIX_DEPENDENCIES = host-gettext ncurses

$(eval $(autotools-package))
