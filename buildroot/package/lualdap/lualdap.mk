################################################################################
#
# lualdap
#
################################################################################

LUALDAP_VERSION = 1.2.5
LUALDAP_SITE = $(call github,lualdap,lualdap,v$(LUALDAP_VERSION))
LUALDAP_LICENSE = MIT
LUALDAP_LICENSE_FILES = LICENSE.md
LUALDAP_DEPENDENCIES = luainterpreter openldap

define LUALDAP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) \
		CC=$(TARGET_CC) \
		LUA_LIB=-llua \
		LUA_LIBDIR="$(STAGING_DIR)/usr/lib" \
		LUA_INCDIR="$(STAGING_DIR)/usr/include" \
		LDAP_LIBDIR="$(STAGING_DIR)/usr/lib" \
		LDAP_INCDIR="$(STAGING_DIR)/usr/include" \
		LBER_LIBDIR="$(STAGING_DIR)/usr/lib" \
		LBER_INCDIR="$(STAGING_DIR)/usr/include" \
		src/lualdap.so
endef

define LUALDAP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) \
		DESTDIR="$(TARGET_DIR)" \
		INST_LIBDIR="/usr/lib/lua/$(LUAINTERPRETER_ABIVER)/" \
		install
endef

$(eval $(generic-package))
