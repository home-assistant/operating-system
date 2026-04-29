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
FFMPEG_VERSION= $(call qstrip,$(BR2_FFMPEG_CUSTOM_VERSION))
FFMPEG_CUSTOM_TARBALL = $(call qstrip,$(BR2_FFMPEG_CUSTOM_TARBALL))
FFMPEG_CUSTOM_CUSTOM_TARBALL_LOCATION = $(call qstrip,$(BR2_FFMPEG_CUSTOM_CUSTOM_TARBALL_LOCATION))
https://code.ffmpeg.org/Kwiboo/FFmpeg/archive/v4l2request-v3.tar.gz
FFMPEG_CUSTOM_REPO_URL = $(call qstrip,$(BR2_FFMPEG_CUSTOM_CUSTOM_REPO_URL))
endif

FFMPEG_VERSION= 3ac4e07593eeeeac8be43e3f6353161a8d1ce8be
FFMPEG_SITE = $(call qstrip,$(BR2_FFMPEG_CUSTOM_CUSTOM_GIT))
FFMPEG_SITE_METHOD = git
FFMPEG_INSTALL_IMAGES = YES
FFMPEG_INSTALL_TARGET = NO
