################################################################################
#
# gst1-interpipe
#
################################################################################

GST1_INTERPIPE_VERSION = 1.1.6
GST1_INTERPIPE_SITE = https://github.com/RidgeRun/gst-interpipe
GST1_INTERPIPE_SITE_METHOD = git
# fetch gst-interpipe/common sub module
GST1_INTERPIPE_GIT_SUBMODULES = YES

GST1_INTERPIPE_LICENSE = LGPL-2.1
GST1_INTERPIPE_LICENSE_FILES = COPYING

GST1_INTERPIPE_DEPENDENCIES = host-pkgconf gstreamer1 gst1-plugins-base

GST1_INTERPIPE_CONF_OPTS = \
	-Dtests=disabled \
	-Denable-gtk-doc=false

$(eval $(meson-package))
