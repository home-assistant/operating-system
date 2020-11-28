################################################################################
#
# libcamera
#
################################################################################

LIBCAMERA_SITE = https://git.linuxtv.org/libcamera.git
LIBCAMERA_VERSION = e59713c68678f3eb6b6ebe97cabdc88c7042567f
LIBCAMERA_SITE_METHOD = git
LIBCAMERA_DEPENDENCIES = \
	host-openssl \
	host-pkgconf \
	host-python3-pyyaml \
	gnutls
LIBCAMERA_CONF_OPTS = \
	-Dandroid=false \
	-Ddocumentation=false \
	-Dtest=false \
	-Dwerror=false
LIBCAMERA_INSTALL_STAGING = YES
LIBCAMERA_LICENSE = \
	LGPL-2.1+ (library), \
	GPL-2.0+ (utils), \
	MIT (qcam/assets/feathericons), \
	BSD-2-Clause (raspberrypi), \
	GPL-2.0 with Linux-syscall-note or BSD-3-Clause (linux kernel headers), \
	CC0-1.0 (meson build system), \
	CC-BY-SA-4.0 (doc)
LIBCAMERA_LICENSE_FILES = \
	LICENSES/LGPL-2.1-or-later.txt \
	LICENSES/GPL-2.0-or-later.txt \
	LICENSES/MIT.txt \
	LICENSES/BSD-2-Clause.txt \
	LICENSES/GPL-2.0-only.txt \
	LICENSES/Linux-syscall-note.txt \
	LICENSES/BSD-3-Clause.txt \
	LICENSES/CC0-1.0.txt \
	LICENSES/CC-BY-SA-4.0.txt

ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_7),y)
LIBCAMERA_CXXFLAGS = -faligned-new
endif

ifeq ($(BR2_PACKAGE_LIBCAMERA_V4L2),y)
LIBCAMERA_CONF_OPTS += -Dv4l2=true
else
LIBCAMERA_CONF_OPTS += -Dv4l2=false
endif

LIBCAMERA_PIPELINES-$(BR2_PACKAGE_LIBCAMERA_PIPELINE_IPU3) += ipu3
ifeq ($(BR2_PACKAGE_LIBCAMERA_PIPELINE_RASPBERRYPI),y)
LIBCAMERA_PIPELINES-y += raspberrypi
LIBCAMERA_DEPENDENCIES += boost
endif
LIBCAMERA_PIPELINES-$(BR2_PACKAGE_LIBCAMERA_PIPELINE_RKISP1) += rkisp1
LIBCAMERA_PIPELINES-$(BR2_PACKAGE_LIBCAMERA_PIPELINE_SIMPLE) += simple
LIBCAMERA_PIPELINES-$(BR2_PACKAGE_LIBCAMERA_PIPELINE_UVCVIDEO) += uvcvideo
LIBCAMERA_PIPELINES-$(BR2_PACKAGE_LIBCAMERA_PIPELINE_VIMC) += vimc

LIBCAMERA_CONF_OPTS += -Dpipelines=$(subst $(space),$(comma),$(LIBCAMERA_PIPELINES-y))

# gstreamer-video-1.0, gstreamer-allocators-1.0
ifeq ($(BR2_PACKAGE_GSTREAMER1)$(BR2_PACKAGE_GST1_PLUGINS_BASE),yy)
LIBCAMERA_CONF_OPTS += -Dgstreamer=enabled
LIBCAMERA_DEPENDENCIES += gstreamer1 gst1-plugins-base
endif

ifeq ($(BR2_PACKAGE_QT5BASE_WIDGETS),y)
LIBCAMERA_CONF_OPTS += -Dqcam=enabled
LIBCAMERA_DEPENDENCIES += qt5base
ifeq ($(BR2_PACKAGE_QT5TOOLS_LINGUIST_TOOLS),y)
LIBCAMERA_DEPENDENCIES += qt5tools
endif
else
LIBCAMERA_CONF_OPTS += -Dqcam=disabled
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
LIBCAMERA_DEPENDENCIES += tiff
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIBCAMERA_DEPENDENCIES += udev
endif

$(eval $(meson-package))
