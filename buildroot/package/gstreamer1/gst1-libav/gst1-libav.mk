################################################################################
#
# gst1-libav
#
################################################################################

GST1_LIBAV_VERSION = 1.18.4
GST1_LIBAV_SOURCE = gst-libav-$(GST1_LIBAV_VERSION).tar.xz
GST1_LIBAV_SITE = https://gstreamer.freedesktop.org/src/gst-libav
GST1_LIBAV_LICENSE = LGPL-2.0+
GST1_LIBAV_LICENSE_FILES = COPYING
GST1_LIBAV_DEPENDENCIES =  host-pkgconf ffmpeg gstreamer1 gst1-plugins-base
GST1_LIBAV_CONF_OPTS = -Ddoc=disabled

$(eval $(meson-package))
