################################################################################
#
# waffle
#
################################################################################

WAFFLE_VERSION = 1.6.1
WAFFLE_SOURCE = waffle-v$(WAFFLE_VERSION).tar.bz2
WAFFLE_SITE = https://gitlab.freedesktop.org/mesa/waffle/-/archive/v$(WAFFLE_VERSION)
WAFFLE_INSTALL_STAGING = YES
WAFFLE_LICENSE = BSD-2-Clause
WAFFLE_LICENSE_FILES = LICENSE.txt

WAFFLE_DEPENDENCIES = host-pkgconf

WAFFLE_CONF_OPTS = -Dwaffle_build_tests=OFF \
	-Dwaffle_build_examples=OFF \
	-Dwaffle_build_manpages=OFF \
	-Dwaffle_build_htmldocs=OFF \
	-Dwaffle_has_nacl=OFF

ifeq ($(BR2_PACKAGE_WAFFLE_SUPPORTS_WAYLAND),y)
WAFFLE_DEPENDENCIES += libegl wayland
WAFFLE_CONF_OPTS += -Dwaffle_has_wayland=ON
else
WAFFLE_CONF_OPTS += -Dwaffle_has_wayland=OFF
endif

ifeq ($(BR2_PACKAGE_WAFFLE_SUPPORTS_X11_EGL),y)
WAFFLE_DEPENDENCIES += libegl libxcb xlib_libX11
WAFFLE_CONF_OPTS += -Dwaffle_has_x11_egl=ON
else
WAFFLE_CONF_OPTS += -Dwaffle_has_x11_egl=OFF
endif

ifeq ($(BR2_PACKAGE_WAFFLE_SUPPORTS_GLX),y)
WAFFLE_DEPENDENCIES += libgl libxcb xlib_libX11
WAFFLE_CONF_OPTS += -Dwaffle_has_glx=ON
else
WAFFLE_CONF_OPTS += -Dwaffle_has_glx=OFF
endif

ifeq ($(BR2_PACKAGE_WAFFLE_SUPPORTS_GBM),y)
WAFFLE_DEPENDENCIES += libegl udev
WAFFLE_CONF_OPTS += -Dwaffle_has_gbm=ON
else
WAFFLE_CONF_OPTS += -Dwaffle_has_gbm=OFF
endif

ifeq ($(BR2_PACKAGE_BASH_COMPLETION),y)
WAFFLE_DEPENDENCIES += bash-completion
endif

ifeq ($(BR2_PACKAGE_MESA3D)$(BR2_PACKAGE_MESA3D_OPENGL_EGL),yy)
WAFFLE_DEPENDENCIES += mesa3d
WAFFLE_CONF_OPTS += -Dwaffle_has_surfaceless_egl=ON
else
WAFFLE_CONF_OPTS += -Dwaffle_has_surfaceless_egl=OFF
endif

$(eval $(cmake-package))
