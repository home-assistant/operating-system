################################################################################
#
# libodb-mysql
#
################################################################################

LIBODB_MYSQL_VERSION_MAJOR = 2.4
LIBODB_MYSQL_VERSION = $(LIBODB_MYSQL_VERSION_MAJOR).0
LIBODB_MYSQL_SOURCE = libodb-mysql-$(LIBODB_MYSQL_VERSION).tar.bz2
LIBODB_MYSQL_SITE = https://www.codesynthesis.com/download/odb/$(LIBODB_MYSQL_VERSION_MAJOR)
LIBODB_MYSQL_INSTALL_STAGING = YES
LIBODB_MYSQL_LICENSE = GPL-2.0
LIBODB_MYSQL_LICENSE_FILES = LICENSE
LIBODB_MYSQL_DEPENDENCIES = libodb mysql
LIBODB_MYSQL_CONF_ENV = LIBS=`$(STAGING_DIR)/usr/bin/mysql_config --libs`

$(eval $(autotools-package))
