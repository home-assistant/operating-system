################################################################################
#
# cifs-utils
#
################################################################################

CIFS_UTILS_VERSION = 6.13
CIFS_UTILS_SOURCE = cifs-utils-$(CIFS_UTILS_VERSION).tar.bz2
CIFS_UTILS_SITE = http://ftp.samba.org/pub/linux-cifs/cifs-utils
CIFS_UTILS_LICENSE = GPL-3.0+
CIFS_UTILS_LICENSE_FILES = COPYING
CIFS_UTILS_CPE_ID_VENDOR = samba
# Missing install-sh in release tarball
CIFS_UTILS_AUTORECONF = YES
CIFS_UTILS_DEPENDENCIES = host-pkgconf

# Let's disable PIE unconditionally. We want PIE to be enabled only by
# the global BR2_RELRO_FULL option.
CIFS_UTILS_CONF_OPTS = --disable-pie --disable-man

# uses C11 code in smbinfo.c and mtab.c
CIFS_UTILS_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=gnu11"

ifeq ($(BR2_PACKAGE_KEYUTILS),y)
CIFS_UTILS_DEPENDENCIES += keyutils
endif

define CIFS_UTILS_NO_WERROR
	$(SED) 's/-Werror//' $(@D)/Makefile.in
endef

CIFS_UTILS_POST_PATCH_HOOKS += CIFS_UTILS_NO_WERROR

ifeq ($(BR2_PACKAGE_CIFS_UTILS_SMBTOOLS),)
define CIFS_UTILS_REMOVE_SMBTOOLS
	rm -f $(TARGET_DIR)/usr/bin/smbinfo
	rm -f $(TARGET_DIR)/usr/bin/smb2-quota
endef
CIFS_UTILS_POST_INSTALL_TARGET_HOOKS += CIFS_UTILS_REMOVE_SMBTOOLS
endif

$(eval $(autotools-package))
