################################################################################
#
# libodb-boost
#
################################################################################

LIBODB_BOOST_VERSION_MAJOR = 2.4
LIBODB_BOOST_VERSION = $(LIBODB_BOOST_VERSION_MAJOR).0
LIBODB_BOOST_SOURCE = libodb-boost-$(LIBODB_BOOST_VERSION).tar.bz2
LIBODB_BOOST_SITE = https://www.codesynthesis.com/download/odb/$(LIBODB_BOOST_VERSION_MAJOR)
LIBODB_BOOST_INSTALL_STAGING = YES
LIBODB_BOOST_LICENSE = GPL-2.0
LIBODB_BOOST_LICENSE_FILES = LICENSE
LIBODB_BOOST_DEPENDENCIES = boost libodb
LIBODB_BOOST_CONF_ENV = CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11"

$(eval $(autotools-package))
