################################################################################
#
# libodb-pgsql
#
################################################################################

LIBODB_PGSQL_VERSION_MAJOR = 2.4
LIBODB_PGSQL_VERSION = $(LIBODB_PGSQL_VERSION_MAJOR).0
LIBODB_PGSQL_SOURCE = libodb-pgsql-$(LIBODB_PGSQL_VERSION).tar.bz2
LIBODB_PGSQL_SITE = https://www.codesynthesis.com/download/odb/$(LIBODB_PGSQL_VERSION_MAJOR)
LIBODB_PGSQL_LICENSE = GPL-2.0
LIBODB_PGSQL_LICENSE_FILES = LICENSE
LIBODB_PGSQL_INSTALL_STAGING = YES
LIBODB_PGSQL_DEPENDENCIES = postgresql libodb

$(eval $(autotools-package))
