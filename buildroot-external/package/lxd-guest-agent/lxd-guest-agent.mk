################################################################################
#
# lxd-guest-agent
#
################################################################################

LXD_GUEST_AGENT_DEPENDENCIES = host-pkgconf

define LXD_GUEST_AGENT_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(LXD_GUEST_AGENT_PKGDIR)/lxd-agent.service \
		$(TARGET_DIR)/usr/lib/systemd/system/lxd-agent.service
	$(INSTALL) -D -m 755 $(LXD_GUEST_AGENT_PKGDIR)/lxd-agent-setup \
		$(TARGET_DIR)/usr/lib/systemd/lxd-agent-setup
	$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs /usr/lib/systemd/system/lxd-agent.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/lxd-agent.service
endef

$(eval $(generic-package))
