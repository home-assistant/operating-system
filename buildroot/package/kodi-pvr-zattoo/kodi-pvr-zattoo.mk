################################################################################
#
# kodi-pvr-zattoo
#
################################################################################

KODI_PVR_ZATTOO_VERSION = 18.1.21-Leia
KODI_PVR_ZATTOO_SITE = $(call github,rbuehlma,pvr.zattoo,$(KODI_PVR_ZATTOO_VERSION))
KODI_PVR_ZATTOO_LICENSE = GPL-2.0+
KODI_PVR_ZATTOO_LICENSE_FILES = debian/copyright
KODI_PVR_ZATTOO_DEPENDENCIES = kodi-platform libplatform rapidjson tinyxml2

$(eval $(cmake-package))
