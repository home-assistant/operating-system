################################################################################
#
# libodb
#
################################################################################

LIBODB_VERSION_MAJOR = 2.4
LIBODB_VERSION = $(LIBODB_VERSION_MAJOR).0
LIBODB_SOURCE = libodb-$(LIBODB_VERSION).tar.bz2
LIBODB_SITE = https://www.codesynthesis.com/download/odb/$(LIBODB_VERSION_MAJOR)
LIBODB_INSTALL_STAGING = YES
LIBODB_LICENSE = GPL-2.0
LIBODB_LICENSE_FILES = LICENSE
LIBODB_CONF_ENV = CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11"

$(eval $(autotools-package))
