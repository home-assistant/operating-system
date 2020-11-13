################################################################################
#
# kodi-pvr-octonet
#
################################################################################

KODI_PVR_OCTONET_VERSION = e35cc373476a92aee11ec8e8a14fb8fc086a4f84
KODI_PVR_OCTONET_SITE = $(call github,DigitalDevices,pvr.octonet,$(KODI_PVR_OCTONET_VERSION))
KODI_PVR_OCTONET_LICENSE = GPL-2.0+
KODI_PVR_OCTONET_LICENSE_FILES = debian/copyright
KODI_PVR_OCTONET_DEPENDENCIES = json-for-modern-cpp kodi-platform libplatform

$(eval $(cmake-package))
