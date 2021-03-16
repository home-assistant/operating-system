################################################################################
#
# librsvg
#
################################################################################

LIBRSVG_VERSION_MAJOR = 2.50
LIBRSVG_VERSION = $(LIBRSVG_VERSION_MAJOR).2
LIBRSVG_SITE = http://ftp.gnome.org/pub/gnome/sources/librsvg/$(LIBRSVG_VERSION_MAJOR)
LIBRSVG_SOURCE = librsvg-$(LIBRSVG_VERSION).tar.xz
LIBRSVG_INSTALL_STAGING = YES
LIBRSVG_CONF_ENV = \
	LIBS=$(TARGET_NLS_LIBS) \
	RUST_TARGET=$(RUSTC_TARGET_NAME)
LIBRSVG_CONF_OPTS = --disable-pixbuf-loader --disable-tools
HOST_LIBRSVG_CONF_OPTS = --enable-introspection=no
LIBRSVG_DEPENDENCIES = cairo host-gdk-pixbuf gdk-pixbuf host-rustc libglib2 libxml2 pango \
	$(TARGET_NLS_DEPENDENCIES)
HOST_LIBRSVG_DEPENDENCIES = host-cairo host-gdk-pixbuf host-libglib2 host-libxml2 host-pango host-rustc
LIBRSVG_LICENSE = LGPL-2.1+
LIBRSVG_LICENSE_FILES = COPYING.LIB
LIBRSVG_CPE_ID_VENDOR = gnome

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
LIBRSVG_CONF_OPTS += --enable-introspection
LIBRSVG_DEPENDENCIES += gobject-introspection
else
LIBRSVG_CONF_OPTS += --disable-introspection
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
