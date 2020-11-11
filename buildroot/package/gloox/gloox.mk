################################################################################
#
# gloox
#
################################################################################

GLOOX_VERSION = 1.0.24
GLOOX_SOURCE = gloox-$(GLOOX_VERSION).tar.bz2
GLOOX_SITE = https://camaya.net/download
GLOOX_LICENSE = GPL-3.0 with OpenSSL exception
GLOOX_LICENSE_FILES = LICENSE
GLOOX_INSTALL_STAGING = YES
GLOOX_DEPENDENCIES = mpc
GLOOX_CONF_OPTS = \
	--without-libidn \
	--enable-getaddrinfo \
	--without-examples \
	--without-tests

GLOOX_CXXFLAGS = $(TARGET_CXXFLAGS)
ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
GLOOX_CXXFLAGS += -O0
endif
GLOOX_CONF_ENV += CXXFLAGS="$(GLOOX_CXXFLAGS)"

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
GLOOX_CONF_ENV += LIBS=-latomic
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
GLOOX_CONF_OPTS += --with-zlib
GLOOX_DEPENDENCIES += zlib
else
GLOOX_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
GLOOX_CONF_OPTS += --with-openssl --without-gnutls
GLOOX_DEPENDENCIES += openssl
else ifeq ($(BR2_PACKAGE_GNUTLS),y)
GLOOX_CONF_OPTS += --with-gnutls --without-openssl
GLOOX_DEPENDENCIES += gnutls
else
GLOOX_CONF_OPTS += --without-gnutls --without-openssl
endif

$(eval $(autotools-package))
