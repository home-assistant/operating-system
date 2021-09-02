################################################################################
#
# dovecot-pigeonhole
#
################################################################################

DOVECOT_PIGEONHOLE_VERSION = 0.5.15
DOVECOT_PIGEONHOLE_SOURCE = dovecot-2.3-pigeonhole-$(DOVECOT_PIGEONHOLE_VERSION).tar.gz
DOVECOT_PIGEONHOLE_SITE = https://pigeonhole.dovecot.org/releases/2.3
DOVECOT_PIGEONHOLE_LICENSE = LGPL-2.1
DOVECOT_PIGEONHOLE_LICENSE_FILES = COPYING
DOVECOT_PIGEONHOLE_CPE_ID_VENDOR = dovecot
DOVECOT_PIGEONHOLE_CPE_ID_PRODUCT = pigeonhole
DOVECOT_PIGEONHOLE_DEPENDENCIES = dovecot

DOVECOT_PIGEONHOLE_CONF_OPTS = --with-dovecot=$(STAGING_DIR)/usr/lib

ifeq ($(BR2_PER_PACKAGE_DIRECTORIES),y)
define DOVECOT_PIGEONHOLE_FIXUP_DOVECOT_CONFIG
	$(SED) 's,$(PER_PACKAGE_DIR)/dovecot/,$(PER_PACKAGE_DIR)/dovecot-pigeonhole/,g' \
		$(STAGING_DIR)/usr/lib/dovecot-config
endef
DOVECOT_PIGEONHOLE_PRE_CONFIGURE_HOOKS = DOVECOT_PIGEONHOLE_FIXUP_DOVECOT_CONFIG
endif

$(eval $(autotools-package))
