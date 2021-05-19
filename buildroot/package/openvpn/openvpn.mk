################################################################################
#
# openvpn
#
################################################################################

OPENVPN_VERSION = 2.5.2
OPENVPN_SOURCE = openvpn-$(OPENVPN_VERSION).tar.xz
OPENVPN_SITE = http://swupdate.openvpn.net/community/releases
OPENVPN_DEPENDENCIES = host-pkgconf
OPENVPN_LICENSE = GPL-2.0
OPENVPN_LICENSE_FILES = COPYRIGHT.GPL
OPENVPN_CPE_ID_VENDOR = openvpn
OPENVPN_CONF_OPTS = \
	--disable-unit-tests \
	$(if $(BR2_STATIC_LIBS),--disable-plugins)
OPENVPN_CONF_ENV = NETSTAT=/bin/netstat

ifeq ($(BR2_PACKAGE_OPENVPN_SMALL),y)
OPENVPN_CONF_OPTS += \
	--enable-small \
	--disable-plugins
endif

ifeq ($(BR2_PACKAGE_OPENVPN_LZ4),y)
OPENVPN_DEPENDENCIES += lz4
else
OPENVPN_CONF_OPTS += --disable-lz4
endif

ifeq ($(BR2_PACKAGE_OPENVPN_LZO),y)
OPENVPN_DEPENDENCIES += lzo
else
OPENVPN_CONF_OPTS += --disable-lzo
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
OPENVPN_DEPENDENCIES += libselinux
OPENVPN_CONF_OPTS += --enable-selinux
else
OPENVPN_CONF_OPTS += --disable-selinux
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
OPENVPN_DEPENDENCIES += linux-pam
OPENVPN_CONF_OPTS += --enable-plugin-auth-pam
else
OPENVPN_CONF_OPTS += --disable-plugin-auth-pam
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
OPENVPN_DEPENDENCIES += openssl
OPENVPN_CONF_OPTS += --with-crypto-library=openssl
else ifeq ($(BR2_PACKAGE_MBEDTLS),y)
OPENVPN_DEPENDENCIES += mbedtls
OPENVPN_CONF_OPTS += --with-crypto-library=mbedtls
endif

ifeq ($(BR2_PACKAGE_PKCS11_HELPER),y)
OPENVPN_DEPENDENCIES += pkcs11-helper
OPENVPN_CONF_OPTS += --enable-pkcs11
else
OPENVPN_CONF_OPTS += --disable-pkcs11
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
OPENVPN_DEPENDENCIES += systemd
OPENVPN_CONF_OPTS += --enable-systemd
else
OPENVPN_CONF_OPTS += --disable-systemd
endif

define OPENVPN_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/openvpn/S60openvpn \
		$(TARGET_DIR)/etc/init.d/S60openvpn
endef

$(eval $(autotools-package))
