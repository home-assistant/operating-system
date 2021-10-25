################################################################################
#
# mtr
#
################################################################################

MTR_VERSION = 0.93
MTR_SITE = $(call github,traviscross,mtr,v$(MTR_VERSION))
MTR_AUTORECONF = YES
MTR_CONF_OPTS = --without-gtk
MTR_DEPENDENCIES = \
	host-pkgconf \
	$(if $(BR2_PACKAGE_LIBCAP),libcap)
MTR_LICENSE = GPL-2.0
MTR_LICENSE_FILES = COPYING
MTR_SELINUX_MODULES = netutils

ifeq ($(BR2_PACKAGE_NCURSES),y)
MTR_CONF_OPTS += --with-ncurses
MTR_DEPENDENCIES += ncurses
else
MTR_CONF_OPTS += --without-ncurses
endif

$(eval $(autotools-package))
