################################################################################
#
# meson-tools
#
################################################################################

HOST_MESON_TOOLS_VERSION = 0a02e2d34413f4bf9b15946352bc8c8ee13a5843
HOST_MESON_TOOLS_SITE = $(call github,afaerber,meson-tools,$(HOST_MESON_TOOLS_VERSION))
HOST_MESON_TOOLS_LICENSE = GPL-2.0+
HOST_MESON_TOOLS_LICENSE_FILES = COPYING
HOST_MESON_TOOLS_DEPENDENCIES = host-openssl

HOST_MESON_TOOLS_PROGS = amlbootsig unamlbootsig amlinfo

define HOST_MESON_TOOLS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS) \
		LDFLAGS="$(HOST_LDFLAGS) -lssl -lcrypto"
endef

define HOST_MESON_TOOLS_INSTALL_CMDS
	$(foreach f,$(HOST_MESON_TOOLS_PROGS), \
		$(INSTALL) -D -m 0755 $(@D)/$(f) $(HOST_DIR)/bin/$(f)
	)
endef

$(eval $(host-generic-package))
