################################################################################
#
# libabseil-cpp
#
################################################################################

LIBABSEIL_CPP_VERSION = 20200923.2
LIBABSEIL_CPP_SITE = $(call github,abseil,abseil-cpp,$(LIBABSEIL_CPP_VERSION))
LIBABSEIL_CPP_LICENSE = Apache-2.0
LIBABSEIL_CPP_LICENSE_FILES = LICENSE
LIBABSEIL_CPP_INSTALL_STAGING = YES

LIBABSEIL_CPP_CONF_OPTS = \
	-DCMAKE_CXX_STANDARD=11 \
	-DABSL_ENABLE_INSTALL=ON \
	-DABSL_USE_GOOGLETEST_HEAD=OFF \
	-DABSL_RUN_TESTS=OFF

HOST_LIBABSEIL_CPP_CONF_OPTS = \
	-DCMAKE_CXX_STANDARD=11 \
	-DABSL_ENABLE_INSTALL=ON \
	-DABSL_USE_GOOGLETEST_HEAD=OFF \
	-DABSL_RUN_TESTS=OFF

$(eval $(cmake-package))
$(eval $(host-cmake-package))
