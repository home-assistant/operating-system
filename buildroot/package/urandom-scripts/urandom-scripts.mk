################################################################################
#
# urandom-scripts
#
################################################################################

define URANDOM_SCRIPTS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(URANDOM_SCRIPTS_PKGDIR)/S20urandom \
		$(TARGET_DIR)/etc/init.d/S20urandom
endef

$(eval $(generic-package))
