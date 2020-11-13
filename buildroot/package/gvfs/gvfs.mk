################################################################################
#
# gvfs
#
################################################################################

GVFS_VERSION_MAJOR = 1.44
GVFS_VERSION = $(GVFS_VERSION_MAJOR).1
GVFS_SOURCE = gvfs-$(GVFS_VERSION).tar.xz
GVFS_SITE = http://ftp.gnome.org/pub/GNOME/sources/gvfs/$(GVFS_VERSION_MAJOR)
GVFS_INSTALL_STAGING = YES
GVFS_DEPENDENCIES = \
	host-pkgconf \
	host-libglib2 \
	dbus \
	gsettings-desktop-schemas \
	libglib2 \
	shared-mime-info \
	$(TARGET_NLS_DEPENDENCIES)
GVFS_LICENSE = LGPL-2.0+
GVFS_LICENSE_FILES = COPYING

GVFS_LDFLAGS = $(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)

# Most of these are missing library support
GVFS_CONF_OPTS = \
	-Dafc=false \
	-Dgoa=false \
	-Dgoogle=false \
	-Dmtp=false \
	-Dsftp=false \
	-Dudisks2=false

ifeq ($(BR2_PACKAGE_AVAHI),y)
GVFS_DEPENDENCIES += avahi
GVFS_CONF_OPTS += -Ddnssd=true
else
GVFS_CONF_OPTS += -Ddnssd=false
endif

ifeq ($(BR2_PACKAGE_GCR),y)
GVFS_DEPENDENCIES += gcr
GVFS_CONF_OPTS += -Dgcr=true
else
GVFS_CONF_OPTS += -Dgcr=false
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
GVFS_DEPENDENCIES += udev
endif

ifeq ($(BR2_PACKAGE_LIBGUDEV),y)
GVFS_DEPENDENCIES += libgudev
GVFS_CONF_OPTS += -Dgudev=true
else
GVFS_CONF_OPTS += -Dgudev=false
endif

ifeq ($(BR2_PACKAGE_LIBARCHIVE),y)
GVFS_DEPENDENCIES += libarchive
GVFS_CONF_OPTS += -Darchive=true
else
GVFS_CONF_OPTS += -Darchive=false
endif

ifeq ($(BR2_PACKAGE_LIBBLURAY),y)
GVFS_DEPENDENCIES += libbluray
GVFS_CONF_OPTS += -Dbluray=true
else
GVFS_CONF_OPTS += -Dbluray=false
endif

ifeq ($(BR2_PACKAGE_LIBCAP)$(BR2_PACKAGE_POLKIT),yy)
GVFS_DEPENDENCIES += libcap polkit
GVFS_CONF_OPTS += -Dadmin=true
else
GVFS_CONF_OPTS += -Dadmin=false
endif

ifeq ($(BR2_PACKAGE_LIBCDIO_PARANOIA)$(BR2_PACKAGE_LIBGUDEV),yy)
GVFS_DEPENDENCIES += libcdio-paranoia libgudev
GVFS_CONF_OPTS += -Dcdda=true
else
GVFS_CONF_OPTS += -Dcdda=false
endif

ifeq ($(BR2_PACKAGE_LIBFUSE3),y)
GVFS_DEPENDENCIES += libfuse3
GVFS_CONF_OPTS += -Dfuse=true
else
GVFS_CONF_OPTS += -Dfuse=false
endif

# AFP support is anon-only without libgcrypt which isn't very useful
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
GVFS_CONF_OPTS += \
	-Dafp=true \
	-Dgcrypt=true
GVFS_DEPENDENCIES += libgcrypt
else
GVFS_CONF_OPTS += \
	-Dafp=false \
	-Dgcrypt=false
endif

ifeq ($(BR2_PACKAGE_LIBGPHOTO2)$(BR2_PACKAGE_LIBGUDEV),yy)
GVFS_DEPENDENCIES += libgphoto2 libgudev
GVFS_CONF_OPTS += -Dgphoto2=true
else
GVFS_CONF_OPTS += -Dgphoto2=false
endif

ifeq ($(BR2_PACKAGE_LIBNFS),y)
GVFS_CONF_OPTS += -Dnfs=true
GVFS_DEPENDENCIES += libnfs
else
GVFS_CONF_OPTS += -Dnfs=false
endif

ifeq ($(BR2_PACKAGE_LIBSECRET),y)
GVFS_DEPENDENCIES += libsecret
GVFS_CONF_OPTS += -Dkeyring=true
else
GVFS_CONF_OPTS += -Dkeyring=false
endif

ifeq ($(BR2_PACKAGE_LIBSOUP)$(BR2_PACKAGE_LIBXML2),yy)
GVFS_DEPENDENCIES += libsoup libxml2
GVFS_CONF_OPTS += -Dhttp=true
else
GVFS_CONF_OPTS += -Dhttp=false
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
GVFS_DEPENDENCIES += libusb
GVFS_CONF_OPTS += -Dlibusb=true
else
GVFS_CONF_OPTS += -Dlibusb=false
endif

ifeq ($(BR2_PACKAGE_SAMBA4),y)
GVFS_DEPENDENCIES += samba4
GVFS_CONF_OPTS += -Dsmb=true
else
GVFS_CONF_OPTS += -Dsmb=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
GVFS_DEPENDENCIES += systemd
GVFS_CONF_OPTS += -Dlogind=true
else
GVFS_CONF_OPTS += \
	-Dlogind=false \
	-Dsystemduserunitdir=no \
	-Dtmpfilesdir=no
endif

define GVFS_REMOVE_TARGET_SCHEMAS
	rm $(TARGET_DIR)/usr/share/glib-2.0/schemas/*.xml
endef

define GVFS_COMPILE_SCHEMAS
	$(HOST_DIR)/bin/glib-compile-schemas --targetdir=$(TARGET_DIR)/usr/share/glib-2.0/schemas $(STAGING_DIR)/usr/share/glib-2.0/schemas
endef

GVFS_POST_INSTALL_TARGET_HOOKS += \
	GVFS_REMOVE_TARGET_SCHEMAS \
	GVFS_COMPILE_SCHEMAS

$(eval $(meson-package))
