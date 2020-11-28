################################################################################
#
# luainterpreter
#
################################################################################

LUAINTERPRETER_ABIVER = $(call qstrip,$(BR2_PACKAGE_LUAINTERPRETER_ABI_VERSION))

# Lua packages often install documentation, clean that up globally
define LUAINTERPRETER_REMOVE_DOC
	rm -rf $(TARGET_DIR)/usr/share/lua/$(LUAINTERPRETER_ABIVER)/doc
endef

LUAINTERPRETER_TARGET_FINALIZE_HOOKS += LUAINTERPRETER_REMOVE_DOC

$(eval $(virtual-package))
$(eval $(host-virtual-package))

LUA_RUN = $(HOST_DIR)/bin/lua
