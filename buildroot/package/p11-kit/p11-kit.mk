################################################################################
#
# p11-kit
#
################################################################################

P11_KIT_VERSION = 0.23.22
P11_KIT_SOURCE = p11-kit-$(P11_KIT_VERSION).tar.xz
P11_KIT_SITE = https://github.com/p11-glue/p11-kit/releases/download/$(P11_KIT_VERSION)
P11_KIT_INSTALL_STAGING = YES
P11_KIT_CONF_OPTS = --disable-static
P11_KIT_CONF_ENV = ac_cv_have_decl_program_invocation_short_name=yes \
	ac_cv_have_decl___progname=no
P11_KIT_LICENSE = BSD-3-Clause
P11_KIT_LICENSE_FILES = COPYING
P11_KIT_CPE_ID_VENDOR = p11-kit_project

ifeq ($(BR2_PACKAGE_LIBFFI),y)
P11_KIT_DEPENDENCIES += host-pkgconf libffi
P11_KIT_CONF_OPTS += --with-libffi
else
P11_KIT_CONF_OPTS += --without-libffi
endif

ifeq ($(BR2_PACKAGE_LIBTASN1),y)
P11_KIT_DEPENDENCIES += host-pkgconf libtasn1
P11_KIT_CONF_OPTS += \
	--enable-trust-module \
	--with-libtasn1
ifeq ($(BR2_PACKAGE_CA_CERTIFICATES),y)
P11_KIT_CONF_OPTS += --with-trust-paths=/etc/ssl/certs/ca-certificates.crt
else
P11_KIT_CONF_OPTS += --without-trust-paths
endif
else
P11_KIT_CONF_OPTS += \
	--disable-trust-module \
	--without-libtasn1
endif

$(eval $(autotools-package))
