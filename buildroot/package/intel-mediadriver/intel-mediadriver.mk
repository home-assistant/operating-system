################################################################################
#
# intel-mediadriver
#
################################################################################

# based on https://software.intel.com/en-us/articles/build-and-debug-open-source-media-stack

INTEL_MEDIADRIVER_VERSION = 19.4.0r
INTEL_MEDIADRIVER_SITE = http://github.com/intel/media-driver/archive
INTEL_MEDIADRIVER_SOURCE= intel-media-$(INTEL_MEDIADRIVER_VERSION).tar.gz
INTEL_MEDIADRIVER_LICENSE = MIT, BSD-3-Clause
INTEL_MEDIADRIVER_LICENSE_FILES = LICENSE.md

INTEL_MEDIADRIVER_DEPENDENCIES = \
	intel-gmmlib \
	libpciaccess \
	libva \
	mesa3d \
	xlib_libX11

INTEL_MEDIADRIVER_SUPPORTS_IN_SOURCE_BUILD = NO

INTEL_MEDIADRIVER_CONF_OPTS = \
	-DINSTALL_DRIVER_SYSCONF=OFF \
	-DMEDIA_BUILD_FATAL_WARNINGS=OFF \
	-DMEDIA_RUN_TEST_SUITE=OFF

$(eval $(cmake-package))
