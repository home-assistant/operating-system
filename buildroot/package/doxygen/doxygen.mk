################################################################################
#
# doxygen
#
################################################################################

DOXYGEN_VERSION = 1.8.18
DOXYGEN_SOURCE = doxygen-$(DOXYGEN_VERSION).src.tar.gz
DOXYGEN_SITE = http://doxygen.nl/files
DOXYGEN_LICENSE = GPL-2.0
DOXYGEN_LICENSE_FILES = LICENSE
DOXYGEN_CPE_ID_VENDOR = doxygen
HOST_DOXYGEN_DEPENDENCIES = host-flex host-bison

HOST_DOXYGEN_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF

$(eval $(host-cmake-package))
