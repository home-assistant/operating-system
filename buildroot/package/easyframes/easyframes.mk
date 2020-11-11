################################################################################
#
# easyframes
#
################################################################################

EASYFRAMES_VERSION = 0.3
EASYFRAMES_SITE = $(call github,microchip-ung,easyframes,v$(EASYFRAMES_VERSION))
EASYFRAMES_DEPENDENCIES = host-pkgconf libpcap
EASYFRAMES_LICENSE = MIT
EASYFRAMES_LICENSE_FILES = COPYING

$(eval $(cmake-package))
