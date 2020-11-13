################################################################################
#
# ebtables
#
################################################################################

EBTABLES_VERSION = 2.0.11
EBTABLES_SITE = http://ftp.netfilter.org/pub/ebtables
EBTABLES_LICENSE = GPL-2.0+
EBTABLES_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_EBTABLES_UTILS_SAVE),y)
define EBTABLES_INSTALL_TARGET_UTILS_SAVE
	$(INSTALL) -m 0755 -D $(@D)/ebtables-save.sh $(TARGET_DIR)/usr/sbin/ebtables-legacy-save
endef
EBTABLES_POST_INSTALL_TARGET_HOOKS += EBTABLES_INSTALL_TARGET_UTILS_SAVE
else
# ebtables-legacy-save is installed by default, thus remove it from target
define EBTABLES_REMOVE_UTILS_SAVE
	$(RM) -f $(TARGET_DIR)/usr/sbin/ebtables-legacy-save
endef
EBTABLES_POST_INSTALL_TARGET_HOOKS += EBTABLES_REMOVE_UTILS_SAVE
endif

# ebtables-legacy-restore is installed by default, thus remove it if not
# selected
ifeq ($(BR2_PACKAGE_EBTABLES_UTILS_RESTORE),)
define EBTABLES_REMOVE_UTILS_RESTORE
	$(RM) -f $(TARGET_DIR)/usr/sbin/ebtables-legacy-restore
endef
EBTABLES_POST_INSTALL_TARGET_HOOKS += EBTABLES_REMOVE_UTILS_RESTORE
endif

$(eval $(autotools-package))
