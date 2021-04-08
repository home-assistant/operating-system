################################################################################
#
# rpm
#
################################################################################

RPM_VERSION_MAJOR = 4.16
RPM_VERSION = $(RPM_VERSION_MAJOR).1.3
RPM_SOURCE = rpm-$(RPM_VERSION).tar.bz2
RPM_SITE = http://ftp.rpm.org/releases/rpm-$(RPM_VERSION_MAJOR).x
RPM_DEPENDENCIES = \
	host-pkgconf \
	$(if $(BR2_PACKAGE_BZIP2),bzip2) \
	$(if $(BR2_PACKAGE_ELFUTILS),elfutils) \
	file \
	popt \
	$(if $(BR2_PACKAGE_XZ),xz) \
	zlib \
	$(TARGET_NLS_DEPENDENCIES)
RPM_LICENSE = GPL-2.0 or LGPL-2.0 (library only)
RPM_LICENSE_FILES = COPYING
RPM_CPE_ID_VENDOR = rpm

# Don't set --{dis,en}-openmp as upstream wants to abort the build if
# --enable-openmp is provided and OpenMP is < 4.5:
# https://github.com/rpm-software-management/rpm/pull/1433
RPM_CONF_OPTS = \
	--disable-python \
	--disable-rpath \
	--with-external-db \
	--with-gnu-ld \
	--without-hackingdocs \
	--without-lua

ifeq ($(BR2_PACKAGE_ACL),y)
RPM_DEPENDENCIES += acl
RPM_CONF_OPTS += --with-acl
else
RPM_CONF_OPTS += --without-acl
endif

ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
RPM_DEPENDENCIES += berkeleydb
RPM_CONF_OPTS += --enable-bdb
else
RPM_CONF_OPTS += --disable-bdb
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
RPM_DEPENDENCIES += dbus
RPM_CONF_OPTS += --enable-plugins
else
RPM_CONF_OPTS += --disable-plugins
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
RPM_DEPENDENCIES += libcap
RPM_CONF_OPTS += --with-cap
else
RPM_CONF_OPTS += --without-cap
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
RPM_DEPENDENCIES += libgcrypt
RPM_CONF_OPTS += --with-crypto=libgcrypt
else ifeq ($(BR2_PACKAGE_LIBNSS),y)
RPM_DEPENDENCIES += libnss
RPM_CONF_OPTS += --with-crypto=nss
RPM_CFLAGS += -I$(STAGING_DIR)/usr/include/nss -I$(STAGING_DIR)/usr/include/nspr
else ifeq ($(BR2_PACKAGE_BEECRYPT),y)
RPM_DEPENDENCIES += beecrypt
RPM_CONF_OPTS += --with-crypto=beecrypt
RPM_CFLAGS += -I$(STAGING_DIR)/usr/include/beecrypt
else
RPM_DEPENDENCIES += openssl
RPM_CONF_OPTS += --with-crypto=openssl
endif

ifeq ($(BR2_PACKAGE_GETTEXT_PROVIDES_LIBINTL),y)
RPM_CONF_OPTS += --with-libintl-prefix=$(STAGING_DIR)/usr
else
RPM_CONF_OPTS += --without-libintl-prefix
endif

ifeq ($(BR2_PACKAGE_LIBARCHIVE),y)
RPM_DEPENDENCIES += libarchive
RPM_CONF_OPTS += --with-archive
else
RPM_CONF_OPTS += --without-archive
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
RPM_DEPENDENCIES += libselinux
RPM_CONF_OPTS += --with-selinux
else
RPM_CONF_OPTS += --without-selinux
endif

ifeq ($(BR2_PACKAGE_SQLITE),y)
RPM_DEPENDENCIES += sqlite
RPM_CONF_OPTS += --enable-sqlite
else
RPM_CONF_OPTS += --disable-sqlite
endif

ifeq ($(BR2_PACKAGE_ZSTD),y)
RPM_DEPENDENCIES += zstd
RPM_CONF_OPTS += --enable-zstd
else
RPM_CONF_OPTS += --disable-zstd
endif

# ac_cv_prog_cc_c99: RPM uses non-standard GCC extensions (ex. `asm`).
RPM_CONF_ENV = \
	ac_cv_prog_cc_c99='-std=gnu99' \
	CFLAGS="$(TARGET_CFLAGS) $(RPM_CFLAGS)" \
	LIBS=$(TARGET_NLS_LIBS)

$(eval $(autotools-package))
