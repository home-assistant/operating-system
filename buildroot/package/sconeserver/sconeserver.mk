################################################################################
#
# sconeserver
#
################################################################################

SCONESERVER_VERSION = 6b932d7d8dbb700b830205e7111e469cefff490c
SCONESERVER_SITE = $(call github,sconemad,sconeserver,$(SCONESERVER_VERSION))
SCONESERVER_LICENSE = GPL-2.0+
SCONESERVER_LICENSE_FILES = COPYING
# fetching from Git, we need to generate the configure script
SCONESERVER_AUTORECONF = YES
SCONESERVER_DEPENDENCIES = \
	host-pkgconf \
	$(if $(BR2_PACKAGE_PCRE),pcre) \
	zlib
# disable image as it fails to build with ImageMagick
# disable markdown module because its git submodule cmark
# https://github.com/sconemad/sconeserver/tree/master/markdown
# has no cross-compile support provided by the sconeserver build system
SCONESERVER_CONF_OPTS += \
	--with-ip \
	--with-local \
	--with-ip6 \
	--without-image \
	--without-markdown

# Sconeserver configure script fails to find the libxml2 headers.
ifeq ($(BR2_PACKAGE_LIBXML2),y)
SCONESERVER_CONF_OPTS += \
	--with-xml2-config="$(STAGING_DIR)/usr/bin/xml2-config"
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
SCONESERVER_DEPENDENCIES += openssl
SCONESERVER_CONF_OPTS += --with-ssl
else
SCONESERVER_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_EXAMPLES),y)
SCONESERVER_CONF_OPTS += --with-examples
else
SCONESERVER_CONF_OPTS += --without-examples
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_HTTP_SCONESITE),y)
SCONESERVER_DEPENDENCIES += libxml2
SCONESERVER_CONF_OPTS += --with-sconesite
else
SCONESERVER_CONF_OPTS += --without-sconesite
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_MYSQL),y)
SCONESERVER_DEPENDENCIES += mysql
SCONESERVER_CONF_OPTS += \
	--with-mysql \
	--with-mysql_config="$(STAGING_DIR)/usr/bin/mysql_config" \
	LDFLAGS="$(TARGET_LDFLAGS) -L$(STAGING_DIR)/usr/lib/mysql"
else
SCONESERVER_CONF_OPTS += --without-mysql
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_BLUETOOTH),y)
SCONESERVER_DEPENDENCIES += bluez5_utils
SCONESERVER_CONF_OPTS += --with-bluetooth
else
SCONESERVER_CONF_OPTS += --without-bluetooth
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_RSS),y)
SCONESERVER_DEPENDENCIES += libxml2
SCONESERVER_CONF_OPTS += --with-rss
else
SCONESERVER_CONF_OPTS += --without-rss
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_LOCATION),y)
SCONESERVER_DEPENDENCIES += gpsd
SCONESERVER_CONF_OPTS += --with-location
else
SCONESERVER_CONF_OPTS += --without-location
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_MATHS),y)
SCONESERVER_DEPENDENCIES += mpfr
SCONESERVER_CONF_OPTS += --with-maths
else
SCONESERVER_CONF_OPTS += --without-maths
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_TESTBUILDER),y)
SCONESERVER_CONF_OPTS += --with-testbuilder
else
SCONESERVER_CONF_OPTS += --without-testbuilder
endif

$(eval $(autotools-package))
