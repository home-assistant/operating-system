################################################################################
#
# libxcb
#
################################################################################

LIBXCB_VERSION = 1.14
LIBXCB_SOURCE = libxcb-$(LIBXCB_VERSION).tar.xz
LIBXCB_SITE = http://xcb.freedesktop.org/dist
LIBXCB_LICENSE = MIT
LIBXCB_LICENSE_FILES = COPYING

LIBXCB_INSTALL_STAGING = YES

LIBXCB_DEPENDENCIES = \
	host-libxslt xcb-proto xlib_libXdmcp xlib_libXau \
	host-xcb-proto host-python3 host-pkgconf
HOST_LIBXCB_DEPENDENCIES = \
	host-libxslt host-xcb-proto host-xlib_libXdmcp \
	host-xlib_libXau host-python3 host-pkgconf

LIBXCB_CONF_OPTS = --with-doxygen=no
HOST_LIBXCB_CONF_OPTS = --with-doxygen=no

# Force detection of Buildroot host-python3 over system python
LIBXCB_CONF_OPTS += ac_cv_path_PYTHON=$(HOST_DIR)/bin/python3
HOST_LIBXCB_CONF_OPTS += ac_cv_path_PYTHON=$(HOST_DIR)/bin/python3

$(eval $(autotools-package))
$(eval $(host-autotools-package))
