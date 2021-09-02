################################################################################
#
# suricata
#
################################################################################

SURICATA_VERSION = 6.0.3
SURICATA_SITE = https://www.openinfosecfoundation.org/download
SURICATA_LICENSE = GPL-2.0
SURICATA_LICENSE_FILES = COPYING LICENSE
# 0001-python-ensure-proper-shabang-on-python-scripts.patch
# 0002-configure.ac-allow-the-user-to-override-RUST_TARGET.patch
SURICATA_AUTORECONF = YES

SURICATA_DEPENDENCIES = \
	host-pkgconf \
	host-rustc \
	jansson \
	$(if $(BR2_PACKAGE_LIBCAP_NG),libcap-ng) \
	$(if $(BR2_PACKAGE_LIBEVENT),libevent) \
	libhtp \
	$(if $(BR2_PACKAGE_LIBNFNETLINK),libnfnetlink) \
	libpcap \
	libyaml \
	$(if $(BR2_PACKAGE_LZ4),lz4) \
	pcre \
	$(if $(BR2_PACKAGE_XZ),xz)

SURICATA_CONF_ENV = \
	ac_cv_path_HAVE_SPHINXBUILD=no \
	CARGO_HOME=$(HOST_DIR)/share/cargo \
	RUST_TARGET=$(RUSTC_TARGET_NAME)

SURICATA_CONF_OPTS = \
	--disable-gccprotect \
	--disable-pie \
	--disable-suricata-update \
	--enable-non-bundled-htp

# install: install binaries
# install-conf: install initial configuration files
# install-full: install binaries, configuration and rules (rules will be
#               download through wget/curl)
SURICATA_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) install install-conf

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
SURICATA_CONF_ENV += LIBS=-latomic
endif

ifeq ($(BR2_PACKAGE_FILE),y)
SURICATA_DEPENDENCIES += file
SURICATA_CONF_OPTS += --enable-libmagic
else
SURICATA_CONF_OPTS += --disable-libmagic
endif

ifeq ($(BR2_PACKAGE_LIBMAXMINDDB),y)
SURICATA_DEPENDENCIES += libmaxminddb
SURICATA_CONF_OPTS += --enable-geoip
else
SURICATA_CONF_OPTS += --disable-geoip
endif

ifeq ($(BR2_PACKAGE_HIREDIS),y)
SURICATA_DEPENDENCIES += hiredis
SURICATA_CONF_OPTS += --enable-hiredis
else
SURICATA_CONF_OPTS += --disable-hiredis
endif

ifeq ($(BR2_PACKAGE_LIBNET),y)
SURICATA_DEPENDENCIES += libnet
SURICATA_CONF_OPTS += --with-libnet-includes=$(STAGING_DIR)/usr/include
endif

ifeq ($(BR2_PACKAGE_LIBNETFILTER_LOG),y)
SURICATA_DEPENDENCIES += libnetfilter_log
SURICATA_CONF_OPTS += --enable-nflog
else
SURICATA_CONF_OPTS += --disable-nflog
endif

ifeq ($(BR2_PACKAGE_LIBNETFILTER_QUEUE),y)
SURICATA_DEPENDENCIES += libnetfilter_queue
SURICATA_CONF_OPTS += --enable-nfqueue
else
SURICATA_CONF_OPTS += --disable-nfqueue
endif

ifeq ($(BR2_PACKAGE_LIBNSPR),y)
SURICATA_DEPENDENCIES += libnspr
SURICATA_CONF_OPTS += --enable-nspr
else
SURICATA_CONF_OPTS += --disable-nspr
endif

ifeq ($(BR2_PACKAGE_LIBNSS),y)
SURICATA_DEPENDENCIES += libnss
SURICATA_CONF_OPTS += --enable-nss
else
SURICATA_CONF_OPTS += --disable-nss
endif

ifeq ($(BR2_PACKAGE_LUA),y)
SURICATA_CONF_OPTS += --enable-lua
SURICATA_DEPENDENCIES += lua
else
SURICATA_CONF_OPTS += --disable-lua
endif

ifeq ($(BR2_PACKAGE_LUAJIT),y)
SURICATA_CONF_OPTS += --enable-luajit
SURICATA_DEPENDENCIES += luajit
else
SURICATA_CONF_OPTS += --disable-luajit
endif

ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
SURICATA_CONF_OPTS += --enable-python
SURICATA_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON),python,python3)
else
SURICATA_CONF_OPTS += --disable-python
endif

define SURICATA_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/suricata/S99suricata \
		$(TARGET_DIR)/etc/init.d/S99suricata
endef

define SURICATA_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/suricata/suricata.service \
		$(TARGET_DIR)/usr/lib/systemd/system/suricata.service
endef

$(eval $(autotools-package))
