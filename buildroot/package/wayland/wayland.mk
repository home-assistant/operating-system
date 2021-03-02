################################################################################
#
# wayland
#
################################################################################

WAYLAND_VERSION = 1.18.0
WAYLAND_SITE = https://wayland.freedesktop.org/releases
WAYLAND_SOURCE = wayland-$(WAYLAND_VERSION).tar.xz
WAYLAND_LICENSE = MIT
WAYLAND_LICENSE_FILES = COPYING
WAYLAND_CPE_ID_VENDOR = wayland
WAYLAND_INSTALL_STAGING = YES
WAYLAND_DEPENDENCIES = host-pkgconf host-wayland expat libffi libxml2
HOST_WAYLAND_DEPENDENCIES = host-pkgconf host-expat host-libffi host-libxml2

WAYLAND_CONF_OPTS = -Dtests=false -Ddocumentation=false
HOST_WAYLAND_CONF_OPTS = -Dtests=false -Ddocumentation=false

# Remove the DTD from the target, it's not needed at runtime
define WAYLAND_TARGET_CLEANUP
	rm -rf $(TARGET_DIR)/usr/share/wayland
endef
WAYLAND_POST_INSTALL_TARGET_HOOKS += WAYLAND_TARGET_CLEANUP

$(eval $(meson-package))
$(eval $(host-meson-package))
