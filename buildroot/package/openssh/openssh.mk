################################################################################
#
# openssh
#
################################################################################

OPENSSH_VERSION_MAJOR = 8.8
OPENSSH_VERSION_MINOR = p1
OPENSSH_VERSION = $(OPENSSH_VERSION_MAJOR)$(OPENSSH_VERSION_MINOR)
OPENSSH_CPE_ID_VERSION = $(OPENSSH_VERSION_MAJOR)
OPENSSH_CPE_ID_UPDATE = $(OPENSSH_VERSION_MINOR)
OPENSSH_SITE = http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable
OPENSSH_LICENSE = BSD-4-Clause, BSD-3-Clause, BSD-2-Clause, Public Domain
OPENSSH_LICENSE_FILES = LICENCE
OPENSSH_CONF_ENV = \
	LD="$(TARGET_CC)" \
	LDFLAGS="$(TARGET_CFLAGS)" \
	LIBS=`$(PKG_CONFIG_HOST_BINARY) --libs openssl`
OPENSSH_CPE_ID_VENDOR = openbsd
OPENSSH_CONF_OPTS = \
	--sysconfdir=/etc/ssh \
	--with-default-path=$(BR2_SYSTEM_DEFAULT_PATH) \
	--disable-lastlog \
	--disable-utmp \
	--disable-utmpx \
	--disable-wtmp \
	--disable-wtmpx \
	--disable-strip

define OPENSSH_PERMISSIONS
	/var/empty d 755 root root - - - - -
endef

ifeq ($(BR2_TOOLCHAIN_SUPPORTS_PIE),)
OPENSSH_CONF_OPTS += --without-pie
endif

OPENSSH_DEPENDENCIES = host-pkgconf zlib openssl

ifeq ($(BR2_PACKAGE_CRYPTODEV_LINUX),y)
OPENSSH_DEPENDENCIES += cryptodev-linux
OPENSSH_CONF_OPTS += --with-ssl-engine
else
OPENSSH_CONF_OPTS += --without-ssl-engine
endif

ifeq ($(BR2_PACKAGE_AUDIT),y)
OPENSSH_DEPENDENCIES += audit
OPENSSH_CONF_OPTS += --with-audit=linux
else
OPENSSH_CONF_OPTS += --without-audit
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
define OPENSSH_INSTALL_PAM_CONF
	$(INSTALL) -D -m 644 $(@D)/contrib/sshd.pam.generic $(TARGET_DIR)/etc/pam.d/sshd
	$(SED) '\%password   required     /lib/security/pam_cracklib.so%d' $(TARGET_DIR)/etc/pam.d/sshd
	$(SED) 's/\#UsePAM no/UsePAM yes/' $(TARGET_DIR)/etc/ssh/sshd_config
endef

OPENSSH_DEPENDENCIES += linux-pam
OPENSSH_CONF_OPTS += --with-pam
OPENSSH_POST_INSTALL_TARGET_HOOKS += OPENSSH_INSTALL_PAM_CONF
else
OPENSSH_CONF_OPTS += --without-pam
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
OPENSSH_DEPENDENCIES += libselinux
OPENSSH_CONF_OPTS += --with-selinux
else
OPENSSH_CONF_OPTS += --without-selinux
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SYSUSERS),y)
define OPENSSH_INSTALL_SYSTEMD_SYSUSERS
	$(INSTALL) -m 0644 -D package/openssh/sshd-sysusers.conf \
		$(TARGET_DIR)/usr/lib/sysusers.d/sshd.conf
endef
else
define OPENSSH_USERS
	sshd -1 sshd -1 * /var/empty - - SSH drop priv user
endef
endif

# Let the default install rule only install the configuration file.
# The programs will be installed based on the config options selected.
OPENSSH_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) install-sysconf

ifeq ($(BR2_PACKAGE_OPENSSH_CLIENT),y)
define OPENSSH_INSTALL_CLIENT_PROGRAMS
	$(INSTALL) -D -m 0755 $(@D)/ssh $(TARGET_DIR)/usr/bin/ssh
	$(INSTALL) -D -m 0755 $(@D)/scp $(TARGET_DIR)/usr/bin/scp
	$(INSTALL) -D -m 0755 $(@D)/sftp $(TARGET_DIR)/usr/bin/sftp
	$(INSTALL) -D -m 0755 $(@D)/ssh-agent $(TARGET_DIR)/usr/bin/ssh-agent
	$(INSTALL) -D -m 0755 $(@D)/ssh-add $(TARGET_DIR)/usr/bin/ssh-add
	$(INSTALL) -D -m 4711 $(@D)/ssh-keysign $(TARGET_DIR)/usr/libexec/ssh-keysign
	$(INSTALL) -D -m 0755 $(@D)/ssh-pkcs11-helper $(TARGET_DIR)/usr/libexec/ssh-pkcs11-helper
	$(INSTALL) -D -m 0755 $(@D)/contrib/ssh-copy-id $(TARGET_DIR)/usr/bin/ssh-copy-id
endef
OPENSSH_POST_INSTALL_TARGET_HOOKS += OPENSSH_INSTALL_CLIENT_PROGRAMS
endif

ifeq ($(BR2_PACKAGE_OPENSSH_SERVER),y)
define OPENSSH_INSTALL_SERVER_PROGRAMS
	$(INSTALL) -D -m 0755 $(@D)/sshd $(TARGET_DIR)/usr/sbin/sshd
	$(INSTALL) -D -m 0755 $(@D)/sftp-server $(TARGET_DIR)/usr/libexec/sftp-server
endef
OPENSSH_POST_INSTALL_TARGET_HOOKS += OPENSSH_INSTALL_SERVER_PROGRAMS

define OPENSSH_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/openssh/sshd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/sshd.service
	$(OPENSSH_INSTALL_SYSTEMD_SYSUSERS)
endef

define OPENSSH_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/openssh/S50sshd \
		$(TARGET_DIR)/etc/init.d/S50sshd
endef
endif

ifeq ($(BR2_PACKAGE_OPENSSH_KEY_UTILS),y)
define OPENSSH_INSTALL_KEY_UTILS
	$(INSTALL) -D -m 0755 $(@D)/ssh-keygen $(TARGET_DIR)/usr/bin/ssh-keygen
	$(INSTALL) -D -m 0755 $(@D)/ssh-keyscan $(TARGET_DIR)/usr/bin/ssh-keyscan
endef
OPENSSH_POST_INSTALL_TARGET_HOOKS += OPENSSH_INSTALL_KEY_UTILS
endif

$(eval $(autotools-package))
