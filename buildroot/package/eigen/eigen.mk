################################################################################
#
# eigen
#
################################################################################

EIGEN_VERSION = 3.3.7
EIGEN_SOURCE = eigen-$(EIGEN_VERSION).tar.bz2
EIGEN_SITE = $(call gitlab,libeigen,eigen,$(EIGEN_VERSION))
EIGEN_LICENSE = MPL2, BSD-3-Clause, LGPL-2.1
EIGEN_LICENSE_FILES = COPYING.MPL2 COPYING.BSD COPYING.LGPL COPYING.README
EIGEN_INSTALL_STAGING = YES
EIGEN_INSTALL_TARGET = NO
EIGEN_SUPPORTS_IN_SOURCE_BUILD = NO

# Default Eigen CMake installs .pc file in /usr/share/pkgconfig
# change it to /usr/lib/pkgconfig, to be consistent with other packages.
EIGEN_CONF_OPTS = -DPKGCONFIG_INSTALL_DIR=/usr/lib/pkgconfig \
	-DCMAKE_Fortran_COMPILER=$(TARGET_FC)

$(eval $(cmake-package))
