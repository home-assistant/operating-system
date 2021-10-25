################################################################################
#
# gstreamer1-editing-services
#
################################################################################

GSTREAMER1_EDITING_SERVICES_VERSION = 1.18.5
GSTREAMER1_EDITING_SERVICES_SOURCE = gst-editing-services-$(GSTREAMER1_EDITING_SERVICES_VERSION).tar.xz
GSTREAMER1_EDITING_SERVICES_SITE = https://gstreamer.freedesktop.org/src/gstreamer-editing-services
GSTREAMER1_EDITING_SERVICES_LICENSE = LGPL-2.0+
GSTREAMER1_EDITING_SERVICES_LICENSE_FILES = COPYING COPYING.LIB
GSTREAMER1_EDITING_SERVICES_INSTALL_STAGING = YES
GSTREAMER1_EDITING_SERVICES_DEPENDENCIES = \
	host-pkgconf \
	gstreamer1 \
	gst1-plugins-base \
	gst1-plugins-good \
	libxml2

GSTREAMER1_EDITING_SERVICES_CONF_OPTS = \
	-Ddoc=disabled \
	-Dexamples=disabled \
	-Dintrospection=disabled \
	-Dtests=disabled \
	-Dtools=enabled \
	-Dbash-completion=disabled \
	-Dxptv=disabled \
	-Dpython=disabled

ifeq ($(BR2_PACKAGE_GST1_DEVTOOLS),y)
GSTREAMER1_EDITING_SERVICES_DEPENDENCIES += gst1-devtools
GSTREAMER1_EDITING_SERVICES_CONF_OPTS += -Dvalidate=enabled
else
GSTREAMER1_EDITING_SERVICES_CONF_OPTS += -Dvalidate=disabled
endif

$(eval $(meson-package))
