################################################################################
#
# efl
#
################################################################################

EFL_VERSION = 1.25.0
EFL_SOURCE = efl-$(EFL_VERSION).tar.xz
EFL_SITE = http://download.enlightenment.org/rel/libs/efl
EFL_LICENSE = BSD-2-Clause, LGPL-2.1+, GPL-2.0+, FTL, MIT
EFL_LICENSE_FILES = \
	COMPLIANCE \
	COPYING \
	COPYING.images \
	licenses/COPYING.ASL \
	licenses/COPYING.BSD \
	licenses/COPYING.FTL \
	licenses/COPYING.GPL \
	licenses/COPYING.LGPL \
	licenses/COPYING.NGINX-MIT \
	licenses/COPYING.SMALL

EFL_INSTALL_STAGING = YES

EFL_DEPENDENCIES = host-pkgconf host-efl host-luajit dbus freetype \
	giflib jpeg libpng luajit lz4 zlib $(TARGET_NLS_DEPENDENCIES)

# Configure options:
# elua=true: build elua for the target.
# sdl=false: disable sdl2 support.
# embedded-lz4=false: use liblz4 from lz4 package.
# native-arch-optimization=false: avoid optimization flags added by meson.
# network-backend=none: disable connman networkmanager.
EFL_CONF_OPTS = \
	-Davahi=false \
	-Dbuild-examples=false \
	-Dbuild-tests=false \
	-Ddotnet=false \
	-Decore-imf-loaders-disabler=ibus,scim,xim \
	-Delua=true \
	-Dembedded-lz4=false \
	-Dlua-interpreter=luajit \
	-Dnative-arch-optimization=false \
	-Dnetwork-backend=none \
	-Dpixman=false \
	-Dsdl=false \
	-Dvnc-server=false

ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
EFL_CONF_OPTS += -Dnls=true
else
EFL_CONF_OPTS += -Dnls=false
endif

EFL_BINDINGS = lua

ifeq ($(BR2_PACKAGE_EFL_EOLIAN_CPP),y)
EFL_BINDINGS += cxx
endif

EFL_CONF_OPTS += -Dbindings=$(subst $(space),$(comma),$(EFL_BINDINGS))

ifeq ($(BR2_PACKAGE_EFL_EEZE),y)
EFL_DEPENDENCIES += udev
EFL_CONF_OPTS += -Deeze=true
else
EFL_CONF_OPTS += -Deeze=false
endif

ifeq ($(BR2_PACKAGE_EFL_UTIL_LINUX_LIBMOUNT),y)
EFL_DEPENDENCIES += util-linux
EFL_CONF_OPTS += -Dlibmount=true
else
EFL_CONF_OPTS += -Dlibmount=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
EFL_CONF_OPTS += -Dsystemd=true
EFL_DEPENDENCIES += systemd
else
EFL_CONF_OPTS += -Dsystemd=false
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
EFL_CONF_OPTS += -Dfontconfig=true
EFL_DEPENDENCIES += fontconfig
else
EFL_CONF_OPTS += -Dfontconfig=false
endif

ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
EFL_CONF_OPTS += -Dfribidi=true
EFL_DEPENDENCIES += libfribidi
else
EFL_CONF_OPTS += -Dfribidi=false
endif

ifeq ($(BR2_PACKAGE_GSTREAMER1)$(BR2_PACKAGE_GST1_PLUGINS_BASE),yy)
EFL_CONF_OPTS += -Dgstreamer=true
EFL_DEPENDENCIES += gstreamer1 gst1-plugins-base
else
EFL_CONF_OPTS += -Dgstreamer=false
endif

ifeq ($(BR2_PACKAGE_BULLET),y)
EFL_CONF_OPTS += -Dphysics=true
EFL_DEPENDENCIES += bullet
else
EFL_CONF_OPTS += -Dphysics=false
endif

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
EFL_CONF_OPTS += -Daudio=true
EFL_DEPENDENCIES += libsndfile
else
EFL_CONF_OPTS += -Daudio=false
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
EFL_CONF_OPTS += -Dpulseaudio=true
EFL_DEPENDENCIES += pulseaudio
else
EFL_CONF_OPTS += -Dpulseaudio=false
endif

ifeq ($(BR2_PACKAGE_HARFBUZZ),y)
EFL_DEPENDENCIES += harfbuzz
EFL_CONF_OPTS += -Dharfbuzz=true
else
EFL_CONF_OPTS += -Dharfbuzz=false
endif

ifeq ($(BR2_PACKAGE_TSLIB),y)
EFL_DEPENDENCIES += tslib
EFL_CONF_OPTS += -Dtslib=true
else
EFL_CONF_OPTS += -Dtslib=false
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
EFL_DEPENDENCIES += libglib2
EFL_CONF_OPTS += -Dglib=true
else
EFL_CONF_OPTS += -Dglib=false
endif

# Prefer openssl (the default) over gnutls.
ifeq ($(BR2_PACKAGE_OPENSSL),y)
EFL_DEPENDENCIES += openssl
EFL_CONF_OPTS += -Dcrypto=openssl
else
EFL_DEPENDENCIES += gnutls libgcrypt
EFL_CONF_OPTS += -Dcrypto=gnutls
endif

ifeq ($(BR2_PACKAGE_EFL_FB),y)
EFL_CONF_OPTS += -Dfb=true
else
EFL_CONF_OPTS += -Dfb=false
endif

ifeq ($(BR2_PACKAGE_EFL_X_XLIB),y)
EFL_CONF_OPTS += -Dx11=true \
	-Dxinput2=true \
	-Dxinput22=true

EFL_DEPENDENCIES += \
	xlib_libX11 \
	xlib_libXcomposite \
	xlib_libXcursor \
	xlib_libXdamage \
	xlib_libXext \
	xlib_libXinerama \
	xlib_libXrandr \
	xlib_libXrender \
	xlib_libXScrnSaver \
	xlib_libXtst
else
EFL_CONF_OPTS += -Dx11=false
endif

ifeq ($(BR2_PACKAGE_EFL_OPENGL),y)
EFL_CONF_OPTS += -Dopengl=full
EFL_DEPENDENCIES += libgl
# OpenGL ES requires EGL
else ifeq ($(BR2_PACKAGE_EFL_OPENGLES),y)
EFL_CONF_OPTS += -Dopengl=es-egl
EFL_DEPENDENCIES += libegl libgles
else ifeq ($(BR2_PACKAGE_EFL_OPENGL_NONE),y)
EFL_CONF_OPTS += -Dopengl=none
endif

ifeq ($(BR2_PACKAGE_EFL_DRM),y)
EFL_CONF_OPTS += -Ddrm=true
EFL_DEPENDENCIES += libdrm libegl libinput mesa3d
else
EFL_CONF_OPTS += -Ddrm=false
endif

ifeq ($(BR2_PACKAGE_EFL_WAYLAND),y)
EFL_DEPENDENCIES += wayland wayland-protocols
EFL_CONF_OPTS += -Dwl=true
else
EFL_CONF_OPTS += -Dwl=false
endif

EFL_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBXKBCOMMON),libxkbcommon)

# json evas loader is disabled by default by upstream.
# Disable libspectre (ps).
# Keep all other evas loader enabled or handled below.
EFL_EVAS_LOADERS_DISABLER = avif gst json ps

# efl already depends on jpeg.
ifeq ($(BR2_PACKAGE_EFL_JPEG),y)
EFL_DEPENDENCIES += openjpeg
else
EFL_EVAS_LOADERS_DISABLER += jp2k
endif

ifeq ($(BR2_PACKAGE_EFL_TIFF),y)
EFL_DEPENDENCIES += tiff
else
EFL_EVAS_LOADERS_DISABLER += tiff
endif

ifeq ($(BR2_PACKAGE_EFL_WEBP),y)
EFL_DEPENDENCIES += webp
else
EFL_EVAS_LOADERS_DISABLER += webp
endif

ifeq ($(BR2_PACKAGE_POPPLER),y)
# poppler needs c++11
EFL_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11"
EFL_DEPENDENCIES += poppler
else
EFL_EVAS_LOADERS_DISABLER += pdf
endif

ifeq ($(BR2_PACKAGE_EFL_LIBRAW),y)
EFL_DEPENDENCIES += libraw
else
EFL_EVAS_LOADERS_DISABLER += raw
endif

ifeq ($(BR2_PACKAGE_EFL_SVG),y)
EFL_DEPENDENCIES += librsvg cairo
else
EFL_EVAS_LOADERS_DISABLER += rsvg
endif

EFL_CONF_OPTS += -Devas-loaders-disabler=$(subst $(space),$(comma),$(EFL_EVAS_LOADERS_DISABLER))

ifeq ($(BR2_PACKAGE_UPOWER),)
# upower ecore system module is only useful if upower
# dbus service is available.
# It's not essential, only used to notify applications
# of power state, such as low battery or AC power, so
# they can adapt their power consumption.
define EFL_HOOK_REMOVE_UPOWER
	rm -fr $(TARGET_DIR)/usr/lib/ecore/system/upower
endef
EFL_POST_INSTALL_TARGET_HOOKS = EFL_HOOK_REMOVE_UPOWER
endif

ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
EFL_DEPENDENCIES += libunwind
endif

$(eval $(meson-package))

################################################################################
#
# host-efl
#
################################################################################

# We want to build only some host tools used later in the build.
# Actually we want: edje_cc, eet and embryo_cc. eolian_cxx is built only
# if selected for the target.

# Host dependencies:
# * host-dbus: for Eldbus
# * host-freetype: for libevas
# * host-libglib2: for libecore
# * host-giflib, host-libjpeg, host-libpng: for libevas image loader
# * host-luajit for Elua tool for the host
# * host-openssl: cryptography backends.
HOST_EFL_DEPENDENCIES = \
	host-pkgconf \
	host-dbus \
	host-freetype \
	host-giflib \
	host-libglib2 \
	host-libjpeg \
	host-libpng \
	host-luajit \
	host-openssl \
	host-zlib

# Configure options:
# audio=false: remove libsndfile dependency.
# eeze=false: remove libudev dependency.
# libmount=false: remove dependency on host-util-linux libmount.
# elua=true: build elua for the host.
# physics=false: remove Bullet dependency.
# network-backend=none: remove network-backend (connman).
# embedded-lz4=true: use lz4 bundled in efl.
HOST_EFL_CONF_OPTS += \
	-Daudio=false \
	-Davahi=false \
	-Dbuild-examples=false \
	-Dbuild-tests=false \
	-Dcrypto=openssl \
	-Ddotnet=false \
	-Decore-imf-loaders-disabler=ibus,scim,xim \
	-Dedje-sound-and-video=false \
	-Deeze=false \
	-Delua=true \
	-Dembedded-lz4=true \
	-Dfontconfig=false \
	-Dfribidi=false \
	-Dglib=true \
	-Dgstreamer=false \
	-Dharfbuzz=false \
	-Dlibmount=false \
	-Dlua-interpreter=luajit \
	-Dnetwork-backend=none \
	-Dnls=false \
	-Dopengl=none \
	-Dphysics=false \
	-Dpixman=false \
	-Dpulseaudio=false \
	-Dsdl=false \
	-Dsystemd=false \
	-Dv4l2=false \
	-Dvnc-server=false \
	-Dx11=false \
	-Dxinput22=false

# List of modular image/vector loaders to disable in efl
HOST_EFL_EVAS_LOADERS_DISABLER = avif bmp dds eet generic gst ico json \
	jp2k pdf pmaps ps psd raw rsvg tga tgv tiff wbmp webp xcf xpm

HOST_EFL_CONF_OPTS += -Devas-loaders-disabler=$(subst $(space),$(comma),$(HOST_EFL_EVAS_LOADERS_DISABLER))

HOST_EFL_BINDINGS = lua

# Enable Eolian language bindings to provide eolian_cxx tool for the
# host which is required to build Eolian language bindings for the
# target.
ifeq ($(BR2_PACKAGE_EFL_EOLIAN_CPP),y)
HOST_EFL_BINDINGS += cxx
endif
HOST_EFL_CONF_OPTS += -Dbindings=$(subst $(space),$(comma),$(HOST_EFL_BINDINGS))

# Always disable upower system module from host as it's
# not useful and would try to use the output/host/var
# system bus which is non-existent and does not contain
# any upower service in it.
define HOST_EFL_HOOK_REMOVE_UPOWER
	rm -fr $(HOST_DIR)/lib/ecore/system/upower
endef
HOST_EFL_POST_INSTALL_HOOKS = HOST_EFL_HOOK_REMOVE_UPOWER

$(eval $(host-meson-package))
