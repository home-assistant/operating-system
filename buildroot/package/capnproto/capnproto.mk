################################################################################
#
# capnproto
#
################################################################################

CAPNPROTO_VERSION = 0.8.0
CAPNPROTO_SITE = $(call github,capnproto,capnproto,v$(CAPNPROTO_VERSION))
CAPNPROTO_LICENSE = MIT
CAPNPROTO_LICENSE_FILES = LICENSE
CAPNPROTO_CPE_ID_VENDOR = capnproto
CAPNPROTO_INSTALL_STAGING = YES
# Fetched from Github with no configure script
CAPNPROTO_AUTORECONF = YES
CAPNPROTO_CONF_OPTS = --with-external-capnp
# Needs the capnproto compiler on the host to generate C++ code from message
# definitions
CAPNPROTO_DEPENDENCIES = host-autoconf host-capnproto
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
CAPNPROTO_CONF_ENV += LIBS=-latomic
endif
# The actual source to be compiled is within a 'c++' subdirectory
CAPNPROTO_SUBDIR = c++

ifeq ($(BR2_PACKAGE_OPENSSL),y)
CAPNPROTO_CONF_OPTS += --with-openssl
CAPNPROTO_DEPENDENCIES += openssl
else
CAPNPROTO_CONF_OPTS += --without-openssl
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
