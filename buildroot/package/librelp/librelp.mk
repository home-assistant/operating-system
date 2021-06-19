################################################################################
#
# librelp
#
################################################################################

LIBRELP_VERSION = 1.9.0
LIBRELP_SITE = http://download.rsyslog.com/librelp
LIBRELP_LICENSE = GPL-3.0+
LIBRELP_LICENSE_FILES = COPYING
LIBRELP_CPE_ID_VENDOR = rsyslog
LIBRELP_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_GNUTLS),y)
LIBRELP_DEPENDENCIES += gnutls host-pkgconf
LIBRELP_CONF_OPTS += --enable-tls
else
LIBRELP_CONF_OPTS += --disable-tls
endif

ifeq ($(BR2_PACKAGE_HAS_OPENSSL),y)
LIBRELP_DEPENDENCIES += openssl host-pkgconf
LIBRELP_CONF_OPTS += --enable-tls-openssl
else
LIBRELP_CONF_OPTS += --disable-tls-openssl
endif

$(eval $(autotools-package))
