################################################################################
#
# wayland-utils
#
################################################################################

WAYLAND_UTILS_VERSION = 1.0.0
WAYLAND_UTILS_SITE = https://wayland.freedesktop.org/releases
WAYLAND_UTILS_SOURCE = wayland-utils-$(WAYLAND_UTILS_VERSION).tar.xz
WAYLAND_UTILS_LICENSE = MIT
WAYLAND_UTILS_LICENSE_FILES = COPYING
WAYLAND_UTILS_DEPENDENCIES = host-pkgconf wayland wayland-protocols

$(eval $(meson-package))
