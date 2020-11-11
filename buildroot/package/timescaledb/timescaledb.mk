################################################################################
#
# timescaledb
#
################################################################################

TIMESCALEDB_VERSION = 1.7.4
TIMESCALEDB_SITE = $(call github,timescale,timescaledb,$(TIMESCALEDB_VERSION))
TIMESCALEDB_LICENSE = Apache-2.0
TIMESCALEDB_LICENSE_FILES = LICENSE

TIMESCALEDB_DEPENDENCIES = postgresql

# The PG_CPPFLAGS, PG_CFLAGS, PG_LDFLAGS and PG_LIBS variables must be
# non-empty, otherwise CMake will call the pg_config script, and our
# pg_config replacement doesn't implement --cppflags --cflags
# --ldflags and --libs.
TIMESCALEDB_CONF_OPTS = \
	-DREGRESS_CHECKS=OFF \
	-DPG_PKGLIBDIR=lib/postgresql \
	-DPG_SHAREDIR=share/postgresql \
	-DPG_BINDIR=bin \
	-DPG_CPPFLAGS="$(TARGET_CPPFLAGS) " \
	-DPG_CFLAGS="$(TARGET_CFLAGS) " \
	-DPG_LDFLAGS="$(TARGET_LDFLAGS) " \
	-DPG_LIBS=" "

# There's no dependency on the OpenSSL package, because USE_OPENSSL
# only tells if postgresql was built with OpenSSL support or not.
ifeq ($(BR2_PACKAGE_OPENSSL),y)
TIMESCALEDB_CONF_OPTS += -DUSE_OPENSSL=1
else
TIMESCALEDB_CONF_OPTS += -DUSE_OPENSSL=0
endif

$(eval $(cmake-package))
