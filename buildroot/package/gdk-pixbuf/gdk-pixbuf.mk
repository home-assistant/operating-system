################################################################################
#
# gdk-pixbuf
#
################################################################################

GDK_PIXBUF_VERSION_MAJOR = 2.42
GDK_PIXBUF_VERSION = $(GDK_PIXBUF_VERSION_MAJOR).2
GDK_PIXBUF_SOURCE = gdk-pixbuf-$(GDK_PIXBUF_VERSION).tar.xz
GDK_PIXBUF_SITE = http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/$(GDK_PIXBUF_VERSION_MAJOR)
GDK_PIXBUF_LICENSE = LGPL-2.1+
GDK_PIXBUF_LICENSE_FILES = COPYING
GDK_PIXBUF_CPE_ID_VENDOR = gnome
GDK_PIXBUF_INSTALL_STAGING = YES
GDK_PIXBUF_DEPENDENCIES = \
	host-gdk-pixbuf host-libglib2 host-pkgconf \
	libglib2 $(if $(BR2_ENABLE_LOCALE),,libiconv)
HOST_GDK_PIXBUF_DEPENDENCIES = host-libpng host-pkgconf host-libglib2

GDK_PIXBUF_CONF_OPTS = \
	-Dgio_sniffing=false \
	-Dinstalled_tests=false \
	-Dman=false

HOST_GDK_PIXBUF_CONF_OPTS = \
	-Dgio_sniffing=false \
	-Dinstalled_tests=false \
	-Dintrospection=disabled \
	-Dman=false

ifeq ($(BR2_STATIC_LIBS),y)
GDK_PIXBUF_CONF_OPTS += -Dbuiltin_loaders=all
endif

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
GDK_PIXBUF_CONF_OPTS += -Dintrospection=enabled
GDK_PIXBUF_DEPENDENCIES += gobject-introspection
else
GDK_PIXBUF_CONF_OPTS += -Dintrospection=disabled
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
GDK_PIXBUF_CONF_OPTS += -Dpng=true
GDK_PIXBUF_DEPENDENCIES += libpng
else
GDK_PIXBUF_CONF_OPTS += -Dpng=false
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
GDK_PIXBUF_CONF_OPTS += -Djpeg=true
HOST_GDK_PIXBUF_CONF_OPTS += -Djpeg=true
GDK_PIXBUF_DEPENDENCIES += jpeg
HOST_GDK_PIXBUF_DEPENDENCIES += host-libjpeg
else
GDK_PIXBUF_CONF_OPTS += -Djpeg=false
HOST_GDK_PIXBUF_CONF_OPTS += -Djpeg=false
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
GDK_PIXBUF_CONF_OPTS += -Dtiff=true
HOST_GDK_PIXBUF_CONF_OPTS += -Dtiff=true
GDK_PIXBUF_DEPENDENCIES += tiff
HOST_GDK_PIXBUF_DEPENDENCIES += host-tiff
else
GDK_PIXBUF_CONF_OPTS += -Dtiff=false
HOST_GDK_PIXBUF_CONF_OPTS += -Dtiff=false
endif

# gdk-pixbuf requires the loaders.cache file populated to work properly
# Rather than doing so at runtime, since the fs can be read-only, do so
# here after building and installing to target.
# And since the cache file will contain absolute host directory names we
# need to sanitize (strip) them.
ifeq ($(BR2_STATIC_LIBS),)
define GDK_PIXBUF_UPDATE_CACHE
	GDK_PIXBUF_MODULEDIR=$(HOST_DIR)/lib/gdk-pixbuf-2.0/2.10.0/loaders \
		$(HOST_DIR)/bin/gdk-pixbuf-query-loaders \
		> $(TARGET_DIR)/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
	$(SED) "s,$(HOST_DIR)/lib,/usr/lib,g" \
		$(TARGET_DIR)/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
endef
GDK_PIXBUF_POST_INSTALL_TARGET_HOOKS += GDK_PIXBUF_UPDATE_CACHE
endif

# Target gdk-pixbuf needs loaders.cache populated to build for the
# thumbnailer. Use the host-built since it matches the target options
# regarding mime types (which is the used information).
define GDK_PIXBUF_COPY_LOADERS_CACHE
	cp -f $(HOST_DIR)/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache \
		$(@D)/gdk-pixbuf
endef
GDK_PIXBUF_PRE_BUILD_HOOKS += GDK_PIXBUF_COPY_LOADERS_CACHE

$(eval $(meson-package))
$(eval $(host-meson-package))
