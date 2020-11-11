################################################################################
#
# openfpgaloader
#
################################################################################

OPENFPGALOADER_VERSION = 381c67de00a3102cf6e9bb20ca84030a71c7a0f2
OPENFPGALOADER_SITE = $(call github,trabucayre,openFPGALoader,$(OPENFPGALOADER_VERSION))
OPENFPGALOADER_LICENSE = AGPL-3.0
OPENFPGALOADER_LICENSE_FILES = LICENSE
OPENFPGALOADER_DEPENDENCIES = libftdi1

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
OPENFPGALOADER_DEPENDENCIES += udev
OPENFPGALOADER_CONF_OPTS += -DENABLE_UDEV=ON
else
OPENFPGALOADER_CONF_OPTS += -DENABLE_UDEV=OFF
endif

$(eval $(cmake-package))
