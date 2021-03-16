################################################################################
#
# xscreensaver
#
################################################################################

XSCREENSAVER_VERSION = 5.45
XSCREENSAVER_SITE = https://www.jwz.org/xscreensaver

# N.B. GPL-2.0+ code (in the hacks/glx subdirectory) is not currently built.
XSCREENSAVER_LICENSE = MIT-like, GPL-2.0+
XSCREENSAVER_LICENSE_FILES = hacks/screenhack.h hacks/glx/chessmodels.h
XSCREENSAVER_CPE_ID_VENDOR = xscreensaver_project

XSCREENSAVER_DEPENDENCIES = \
	gdk-pixbuf \
	jpeg \
	libgtk2 \
	libxml2 \
	xlib_libX11 \
	xlib_libXt \
	$(TARGET_NLS_DEPENDENCIES) \
	host-intltool

# otherwise we end up with host include/library dirs passed to the
# compiler/linker
XSCREENSAVER_CONF_OPTS = \
	--includedir=$(STAGING_DIR)/usr/include \
	--libdir=$(STAGING_DIR)/usr/lib

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
XSCREENSAVER_CONF_OPTS += --with-gl=yes
XSCREENSAVER_DEPENDENCIES += libgl libglu
else
XSCREENSAVER_CONF_OPTS += --with-gl=no
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
XSCREENSAVER_CONF_OPTS += --with-png=yes
XSCREENSAVER_DEPENDENCIES += libpng
else
XSCREENSAVER_CONF_OPTS += --with-png=no
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
XSCREENSAVER_CONF_OPTS += --with-systemd=yes
XSCREENSAVER_DEPENDENCIES += systemd
else
XSCREENSAVER_CONF_OPTS += --with-systemd=no
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT),y)
XSCREENSAVER_CONF_OPTS += --with-xft=yes
XSCREENSAVER_DEPENDENCIES += xlib_libXft
else
XSCREENSAVER_CONF_OPTS += --with-xft=no
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXI),y)
XSCREENSAVER_CONF_OPTS += --with-xinput-ext=yes
XSCREENSAVER_DEPENDENCIES += xlib_libXi
else
XSCREENSAVER_CONF_OPTS += --with-xinput-ext=no
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
XSCREENSAVER_CONF_OPTS += --with-xinerama-ext=yes
XSCREENSAVER_DEPENDENCIES += xlib_libXinerama
else
XSCREENSAVER_CONF_OPTS += --with-xinerama-ext=no
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
XSCREENSAVER_CONF_OPTS += --with-randr-ext=yes
XSCREENSAVER_DEPENDENCIES += xlib_libXrandr
else
XSCREENSAVER_CONF_OPTS += --with-randr-ext=no
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXXF86VM),y)
XSCREENSAVER_CONF_OPTS += --with-xf86vmode-ext=yes
XSCREENSAVER_DEPENDENCIES += xlib_libXxf86vm
else
XSCREENSAVER_CONF_OPTS += --with-xf86vmode-ext=no
endif

XSCREENSAVER_INSTALL_TARGET_OPTS = install_prefix="$(TARGET_DIR)" install

$(eval $(autotools-package))
