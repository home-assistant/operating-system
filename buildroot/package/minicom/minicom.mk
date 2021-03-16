################################################################################
#
# minicom
#
################################################################################

MINICOM_VERSION = 2.8
MINICOM_SOURCE = minicom-$(MINICOM_VERSION).tar.bz2
MINICOM_SITE = \
	https://salsa.debian.org/minicom-team/minicom/-/archive/$(MINICOM_VERSION)
MINICOM_LICENSE = GPL-2.0+
MINICOM_LICENSE_FILES = COPYING
MINICOM_CPE_ID_VENDOR = minicom_project
MINICOM_AUTORECONF = YES

MINICOM_DEPENDENCIES = ncurses $(if $(BR2_ENABLE_LOCALE),,libiconv) \
	$(TARGET_NLS_DEPENDENCIES) host-pkgconf
# add host-gettext for AM_ICONV macro
MINICOM_DEPENDENCIES += host-gettext

MINICOM_CONF_OPTS = \
	--enable-dfl-port=/dev/ttyS1 \
	--enable-lock-dir=/var/lock

$(eval $(autotools-package))
