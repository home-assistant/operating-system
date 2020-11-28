################################################################################
#
# resiprocate
#
################################################################################

RESIPROCATE_VERSION = 1.12.0
RESIPROCATE_SITE =  https://www.resiprocate.org/files/pub/reSIProcate/releases
# For complete details see https://www.resiprocate.org/License
RESIPROCATE_LICENSE = VSL-1.0, BSD-3-Clause
RESIPROCATE_LICENSE_FILES = COPYING
RESIPROCATE_INSTALL_STAGING = YES

# Utilize c-ares from buildroot instead built in ARES library
# NOTE: resiprocate doesn't support --without-<feature> syntax as it will try
#       to build with package if specified
RESIPROCATE_DEPENDENCIES = c-ares
RESIPROCATE_CONF_OPTS = -with-c-ares \
	--with-sysroot="$(STAGING_DIR)"

ifeq ($(BR2_PACKAGE_OPENSSL),y)
RESIPROCATE_DEPENDENCIES += openssl host-pkgconf
RESIPROCATE_CONF_OPTS += --with-ssl
# Configure.ac does not include '-lz' when statically linking against openssl
RESIPROCATE_CONF_ENV += LIBS=`$(PKG_CONFIG_HOST_BINARY) --libs openssl`
endif

ifeq ($(BR2_PACKAGE_POPT),y)
RESIPROCATE_CONF_OPTS += --with-popt
RESIPROCATE_DEPENDENCIES += popt
endif

ifeq ($(BR2_PACKAGE_RESIPROCATE_DTLS_SUPPORT),y)
RESIPROCATE_CONF_OPTS += --with-dtls
endif

ifeq ($(BR2_PACKAGE_RESIPROCATE_REND),y)
RESIPROCATE_CONF_OPTS += --with-rend
RESIPROCATE_DEPENDENCIES += boost
endif

ifeq ($(BR2_PACKAGE_RESIPROCATE_APPS),y)
RESIPROCATE_CONF_OPTS += --with-apps
RESIPROCATE_DEPENDENCIES += pcre
endif

$(eval $(autotools-package))
