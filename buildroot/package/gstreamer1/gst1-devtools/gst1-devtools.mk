################################################################################
#
# gst1-devtools
#
################################################################################

GST1_DEVTOOLS_VERSION = 1.18.4
GST1_DEVTOOLS_SOURCE = gst-devtools-$(GST1_DEVTOOLS_VERSION).tar.xz
GST1_DEVTOOLS_SITE = https://gstreamer.freedesktop.org/src/gst-devtools
GST1_DEVTOOLS_LICENSE = LGPL-2.1+
GST1_DEVTOOLS_LICENSE_FILES = validate/COPYING
GST1_DEVTOOLS_INSTALL_STAGING = YES

GST1_DEVTOOLS_DEPENDENCIES = \
	gstreamer1 \
	gst1-plugins-base \
	json-glib \
	$(if $(BR2_PACKAGE_CAIRO),cairo)

ifeq ($(BR2_PACKAGE_PYTHON3),y)
GST1_DEVTOOLS_DEPENDENCIES += host-python3 python3
else
GST1_DEVTOOLS_DEPENDENCIES += host-python python
endif

ifeq ($(BR2_PACKAGE_GST1_RTSP_SERVER),y)
GST1_DEVTOOLS_DEPENDENCIES += gst1-rtsp-server
endif

GST1_DEVTOOLS_CONF_OPTS = \
	-Dvalidate=enabled \
	-Ddebug_viewer=disabled \
	-Dintrospection=disabled \
	-Dtests=disabled \
	-Ddoc=disabled

$(eval $(meson-package))
