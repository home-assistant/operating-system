################################################################################
#
# zziplib
#
################################################################################

ZZIPLIB_VERSION = 0.13.72
ZZIPLIB_SITE = $(call github,gdraheim,zziplib,v$(ZZIPLIB_VERSION))
ZZIPLIB_LICENSE = LGPL-2.0+ or MPL-1.1
ZZIPLIB_LICENSE_FILES = docs/COPYING.LIB docs/COPYING.MPL docs/copying.htm
ZZIPLIB_CPE_ID_VALID = YES
ZZIPLIB_INSTALL_STAGING = YES
ZZIPLIB_CONF_OPTS += \
	-DZZIPDOCS=OFF \
	-DZZIPTEST=OFF
ZZIPLIB_DEPENDENCIES = host-pkgconf zlib

define ZZIPLIB_POST_EXTRACT_FIXUP
	rm $(@D)/GNUmakefile
endef
ZZIPLIB_POST_EXTRACT_HOOKS += ZZIPLIB_POST_EXTRACT_FIXUP

ifeq ($(BR2_PACKAGE_SDL2),y)
ZZIPLIB_CONF_OPTS += -DZZIPSDL=ON
ZZIPLIB_DEPENDENCIES += sdl2
else
ZZIPLIB_CONF_OPTS += -DZZIPSDL=OFF
endif

$(eval $(cmake-package))
