################################################################################
#
# vcgencmd
#
################################################################################

VCGENCMD_VERSION = c57d8c29c46993d93f191218bbc1dc3a73fc7918
VCGENCMD_SITE = $(call github,raspberrypi,utils,$(VCGENCMD_VERSION))
VCGENCMD_LICENSE = BSD-3-Clause
VCGENCMD_LICENSE_FILES = LICENSE
VCGENCMD_SUBDIR = vcgencmd

define VCGENCMD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/vcgencmd/vcgencmd $(TARGET_DIR)/usr/bin/vcgencmd
endef

$(eval $(cmake-package))
