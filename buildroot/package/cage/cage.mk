################################################################################
#
# cage
#
################################################################################

CAGE_VERSION = 0.1.2.1
CAGE_SITE = https://github.com/Hjdskes/cage/releases/download/v$(CAGE_VERSION)
CAGE_LICENSE = MIT
CAGE_LICENSE_FILES = LICENSE
CAGE_DEPENDENCIES = host-pkgconf wlroots

ifeq ($(BR2_PACKAGE_XORG7),y)
CAGE_CONF_OPTS = -Dxwayland=true
else
CAGE_CONF_OPTS = -Dxwayland=false
endif

$(eval $(meson-package))
