################################################################################
#
# ffmpeg
#
################################################################################

# Set variables depending on whether we are using FFMPEG from specific location
# build or a standalone header package.

# FFMPEG 8.0.1 sourve with v4l2-request API.  https://code.ffmpeg.org/FFmpeg/FFmpeg/pulls/20847
# https://code.ffmpeg.org/Kwiboo/FFmpeg.git -b v4l2-request-n8.0.1 ffmpeg \

ifeq ($(BR2_PACKAGE_FFMPEG_CUSTOM),y)
FFMPEG_SITE= $(call qstrip,$(BR2_PACKAGE_FFMPEG_CUSTOM_GIT_REPO))
FFMPEG_VERSION= $(call qstrip,$(BR2_PACKAGE_FFMPEG_CUSTOM_GIT_REPO_VERSION))
endif

FFMPEG_SITE_METHOD = git
FFMPEG_INSTALL_IMAGES = YES
FFMPEG_INSTALL_TARGET = NO

define HELLO_BUILD_CMDS
    $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)
endef

define HELLO_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 0755 $(@D)/hello $(TARGET_DIR)/usr/bin
endef


$(eval $(generic-package))
