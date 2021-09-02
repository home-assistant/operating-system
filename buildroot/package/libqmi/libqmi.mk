################################################################################
#
# libqmi
#
################################################################################

LIBQMI_VERSION = 1.26.6
LIBQMI_SITE = http://www.freedesktop.org/software/libqmi
LIBQMI_SOURCE = libqmi-$(LIBQMI_VERSION).tar.xz
LIBQMI_LICENSE = LGPL-2.0+ (library), GPL-2.0+ (programs)
LIBQMI_LICENSE_FILES = COPYING COPYING.LIB
LIBQMI_CPE_ID_VENDOR = libqmi_project
LIBQMI_INSTALL_STAGING = YES

LIBQMI_DEPENDENCIES = libglib2

LIBQMI_CONF_OPTS = --disable-Werror

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
LIBQMI_DEPENDENCIES += gobject-introspection
LIBQMI_CONF_OPTS += --enable-introspection
else
LIBQMI_CONF_OPTS += --disable-introspection
endif

# if libgudev available, request udev support for a better
# qmi-firmware-update experience
ifeq ($(BR2_PACKAGE_LIBGUDEV),y)
LIBQMI_DEPENDENCIES += libgudev
LIBQMI_CONF_OPTS += --with-udev
else
LIBQMI_CONF_OPTS += --without-udev
endif

# if libmbim available, request QMI-over-MBIM support
ifeq ($(BR2_PACKAGE_LIBMBIM),y)
LIBQMI_DEPENDENCIES += libmbim
LIBQMI_CONF_OPTS += --enable-mbim-qmux
else
LIBQMI_CONF_OPTS += --disable-mbim-qmux
endif

# if ModemManager available, enable MM runtime check in
# qmi-firmware-update (note that we don't need to build-depend on
# anything else)
ifeq ($(BR2_PACKAGE_MODEM_MANAGER),y)
LIBQMI_CONF_OPTS += --enable-mm-runtime-check
else
LIBQMI_CONF_OPTS += --disable-mm-runtime-check
endif

$(eval $(autotools-package))
