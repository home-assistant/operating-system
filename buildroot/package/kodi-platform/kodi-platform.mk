################################################################################
#
# kodi-platform
#
################################################################################

KODI_PLATFORM_VERSION = 809c5e9d711e378561440a896fcb7dbcd009eb3d
KODI_PLATFORM_SITE = $(call github,xbmc,kodi-platform,$(KODI_PLATFORM_VERSION))
KODI_PLATFORM_LICENSE = GPL-2.0+
KODI_PLATFORM_LICENSE_FILES = debian/copyright
KODI_PLATFORM_INSTALL_STAGING = YES
KODI_PLATFORM_DEPENDENCIES = libplatform kodi

$(eval $(cmake-package))
