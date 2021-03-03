################################################################################
#
# nvidia-modprobe
#
################################################################################

NVIDIA_MODPROBE_VERSION = 450.57
NVIDIA_MODPROBE_SITE = $(call github,NVIDIA,nvidia-modprobe,$(NVIDIA_MODPROBE_VERSION))
NVIDIA_MODPROBE_LICENSE = GPL-2.0
NVIDIA_MODPROBE_LICENSE_FILES = COPYING

define NVIDIA_MODPROBE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		OUTPUTDIR=. ./nvidia-modprobe.unstripped
endef

define NVIDIA_MODPROBE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/nvidia-modprobe.unstripped \
		$(TARGET_DIR)/usr/bin/nvidia-modprobe
endef

$(eval $(generic-package))
