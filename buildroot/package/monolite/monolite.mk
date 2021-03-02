################################################################################
#
# monolite
#
################################################################################

MONOLITE_VERSION = 1A5E0066-58DC-428A-B21C-0AD6CDAE2789
MONOLITE_SITE = http://download.mono-project.com/monolite
MONOLITE_SOURCE = monolite-linux-$(MONOLITE_VERSION)-latest.tar.gz
MONOLITE_LICENSE = LGPL-2.0 or commercial

define HOST_MONOLITE_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/lib/monolite-linux/$(MONOLITE_VERSION)
	cp -r $(@D)/* $(HOST_DIR)/lib/monolite-linux/$(MONOLITE_VERSION)
endef

$(eval $(host-generic-package))
