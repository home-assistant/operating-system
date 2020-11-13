################################################################################
#
# mg
#
################################################################################

MG_VERSION = 3.4
MG_SITE = https://github.com/troglobit/mg/releases/download/v$(MG_VERSION)
MG_LICENSE = Public Domain
MG_LICENSE_FILES = UNLICENSE

ifeq ($(BR2_PACKAGE_NCURSES),y)
MG_DEPENDENCIES += ncurses
MG_CONF_OPTS += --with-curses
else
MG_CONF_OPTS += --without-curses
endif

$(eval $(autotools-package))
