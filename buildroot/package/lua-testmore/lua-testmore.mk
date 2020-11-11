################################################################################
#
# lua-testmore
#
################################################################################

LUA_TESTMORE_VERSION = 0.3.5-2
LUA_TESTMORE_NAME_UPSTREAM = lua-TestMore
LUA_TESTMORE_LICENSE = MIT
LUA_TESTMORE_LICENSE_FILES = $(LUA_TESTMORE_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
