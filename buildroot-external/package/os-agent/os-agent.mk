################################################################################
#
# foo
#
################################################################################

OS_AGENT_VERSION = a8acb25adec4dc7d3a01c17c12bb88700ecb5ed1
OS_AGENT_SITE = $(call github,agners,home-assistant-os-agent,$(OS_AGENT_VERSION))
OS_AGENT_LICENSE = Apache License 2.0
OS_AGENT_LICENSE_FILES = LICENSE
OS_AGENT_GOMOD = github.com/home-assistant/os-agent

define OS_AGENT_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/contrib/io.homeassistant.conf \
		$(TARGET_DIR)/etc/dbus-1/system.d/io.homeassistant.conf
	$(INSTALL) -D -m 0644 $(@D)/contrib/haos-agent.service \
		$(TARGET_DIR)/usr/lib/systemd/system/haos-agent.service
endef

$(eval $(golang-package))
