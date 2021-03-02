################################################################################
#
# mutt
#
################################################################################

MUTT_VERSION = 1.14.7
MUTT_SITE = https://bitbucket.org/mutt/mutt/downloads
MUTT_LICENSE = GPL-2.0+
MUTT_LICENSE_FILES = GPL
MUTT_CPE_ID_VENDOR = mutt
MUTT_DEPENDENCIES = ncurses
MUTT_CONF_OPTS = --disable-doc --disable-smtp

# 0001-Ensure-IMAP-connection-is-closed-after-a-connection-error.patch
MUTT_IGNORE_CVES += CVE-2020-28896

# 0002-CVE-2021-3181-1.patch
# 0003-CVE-2021-3181-2.patch
# 0004-CVE-2021-3181-3.patch
MUTT_IGNORE_CVES += CVE-2021-3181

ifeq ($(BR2_PACKAGE_LIBICONV),y)
MUTT_DEPENDENCIES += libiconv
MUTT_CONF_OPTS += --enable-iconv
endif

# Both options can't be selected at the same time so prefer libidn2
ifeq ($(BR2_PACKAGE_LIBIDN2),y)
MUTT_DEPENDENCIES += libidn2
MUTT_CONF_OPTS += --with-idn2 --without-idn
else ifeq ($(BR2_PACKAGE_LIBIDN),y)
MUTT_DEPENDENCIES += libidn
MUTT_CONF_OPTS += --with-idn --without-idn2
else
MUTT_CONF_OPTS += --without-idn --without-idn2
endif

ifeq ($(BR2_PACKAGE_LIBGPGME),y)
MUTT_DEPENDENCIES += libgpgme
MUTT_CONF_OPTS += \
	--enable-gpgme \
	--with-gpgme-prefix=$(STAGING_DIR)/usr
else
MUTT_CONF_OPTS += --disable-gpgme
endif

ifeq ($(BR2_PACKAGE_MUTT_IMAP),y)
MUTT_CONF_OPTS += --enable-imap
else
MUTT_CONF_OPTS += --disable-imap
endif

ifeq ($(BR2_PACKAGE_MUTT_POP3),y)
MUTT_CONF_OPTS += --enable-pop
else
MUTT_CONF_OPTS += --disable-pop
endif

# SSL support is only used by imap or pop3 module
ifneq ($(BR2_PACKAGE_MUTT_IMAP)$(BR2_PACKAGE_MUTT_POP3),)
ifeq ($(BR2_PACKAGE_OPENSSL),y)
MUTT_DEPENDENCIES += openssl
MUTT_CONF_OPTS += \
	--without-gnutls \
	--with-ssl=$(STAGING_DIR)/usr
else ifeq ($(BR2_PACKAGE_GNUTLS),y)
MUTT_DEPENDENCIES += gnutls
MUTT_CONF_OPTS += \
	--with-gnutls=$(STAGING_DIR)/usr \
	--without-ssl
else
MUTT_CONF_OPTS += \
	--without-gnutls \
	--without-ssl
endif
else
MUTT_CONF_OPTS += \
	--without-gnutls \
	--without-ssl
endif

ifeq ($(BR2_PACKAGE_SQLITE),y)
MUTT_DEPENDENCIES += sqlite
MUTT_CONF_OPTS += --with-sqlite3
else
MUTT_CONF_OPTS += --without-sqlite3
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
MUTT_DEPENDENCIES += zlib
MUTT_CONF_OPTS += --with-zlib=$(STAGING_DIR)/usr
else
MUTT_CONF_OPTS += --without-zlib
endif

# Avoid running tests to check for:
#  - target system is *BSD
#  - C99 conformance (snprintf, vsnprintf)
#  - behaviour of the regex library
#  - if mail spool directory is world/group writable
#  - we have a working libiconv
MUTT_CONF_ENV += \
	mutt_cv_bsdish=no \
	mutt_cv_c99_snprintf=yes \
	mutt_cv_c99_vsnprintf=yes \
	mutt_cv_regex_broken=no \
	mutt_cv_worldwrite=yes \
	mutt_cv_groupwrite=yes \
	mutt_cv_iconv_good=yes \
	mutt_cv_iconv_nontrans=no

MUTT_CONF_OPTS += --with-mailpath=/var/mail

define MUTT_VAR_MAIL
	mkdir -p $(TARGET_DIR)/var
	ln -sf /tmp $(TARGET_DIR)/var/mail
endef
MUTT_POST_INSTALL_TARGET_HOOKS += MUTT_VAR_MAIL

$(eval $(autotools-package))
