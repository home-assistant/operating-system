################################################################################
#
# batman-adv
#
################################################################################

BATMAN_ADV_VERSION = 2019.3
BATMAN_ADV_SITE = https://downloads.open-mesh.org/batman/stable/sources/batman-adv
BATMAN_ADV_LICENSE = GPL-2.0, MIT (batman_adv.h)
BATMAN_ADV_LICENSE_FILES = LICENSES/preferred/GPL-2.0 LICENSES/preferred/MIT

BATMAN_ADV_CFLAGS = \
	-I$(@D)/compat-include/ \
	-I$(@D)/include/ \
	-include $(@D)/compat.h \
	-DBATADV_SOURCE_VERSION=\"\\\"$(BATMAN_ADV_VERSION)\\\"\"

# Bridge Loop Avoidance, Distributed Arp Table are always enabled
BATMAN_ADV_MODULE_MAKE_OPTS = \
	KVER=$(LINUX_VERSION_PROBED) \
	INSTALL_MOD_DIR=updates/net/batman-adv \
	NOSTDINC_FLAGS="$(BATMAN_ADV_CFLAGS)" \
	CONFIG_BATMAN_ADV=m \
	CONFIG_BATMAN_ADV_BLA=y \
	CONFIG_BATMAN_ADV_DAT=y \
	CONFIG_BATMAN_ADV_MCAST=y \
	CONFIG_BATMAN_ADV_BATMAN_V=$(if $(BR2_PACKAGE_BATMAN_ADV_BATMAN_V),y,n) \
	CONFIG_BATMAN_ADV_DEBUG=$(if $(BR2_PACKAGE_BATMAN_ADV_DEBUG),y,n) \
	CONFIG_BATMAN_ADV_NC=$(if $(BR2_PACKAGE_BATMAN_ADV_NC),y,n)

BATMAN_ADV_MODULE_SUBDIRS = net/batman-adv

define BATMAN_ADV_CONFIGURE_CMDS
	$(BATMAN_ADV_MODULE_MAKE_OPTS) $(@D)/gen-compat-autoconf.sh $(@D)/compat-autoconf.h
endef

define BATMAN_ADV_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_LIBCRC32C)
endef

$(eval $(kernel-module))
$(eval $(generic-package))
