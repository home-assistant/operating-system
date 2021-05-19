################################################################################
#
# libupnp
#
################################################################################

LIBUPNP_VERSION = 1.14.6
LIBUPNP_SOURCE = libupnp-$(LIBUPNP_VERSION).tar.bz2
LIBUPNP_SITE = \
	http://downloads.sourceforge.net/project/pupnp/release-$(LIBUPNP_VERSION)
LIBUPNP_CONF_ENV = ac_cv_lib_compat_ftime=no
LIBUPNP_INSTALL_STAGING = YES
LIBUPNP_LICENSE = BSD-3-Clause
LIBUPNP_LICENSE_FILES = COPYING
LIBUPNP_CPE_ID_VENDOR = libupnp_project
LIBUPNP_DEPENDENCIES = host-pkgconf

# Bind the internal miniserver socket with reuseaddr to allow clean restarts.
LIBUPNP_CONF_OPTS += \
	--disable-samples \
	--enable-reuseaddr

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBUPNP_CONF_OPTS += --enable-open-ssl
LIBUPNP_DEPENDENCIES += openssl
else
LIBUPNP_CONF_OPTS += --disable-open-ssl
endif

$(eval $(autotools-package))
