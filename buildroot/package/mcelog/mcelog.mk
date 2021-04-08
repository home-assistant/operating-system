################################################################################
#
# mcelog
#
################################################################################

MCELOG_VERSION = 172
MCELOG_SITE = $(call github,andikleen,mcelog,v$(MCELOG_VERSION))
MCELOG_LICENSE = GPL-2.0
MCELOG_LICENSE_FILES = LICENSE
MCELOG_SELINUX_MODULES = mcelog

define MCELOG_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define MCELOG_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define MCELOG_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/mcelog.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mcelog.service
endef

$(eval $(generic-package))
