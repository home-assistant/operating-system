################################################################################
#
# luasyslog
#
################################################################################

LUASYSLOG_VERSION = 2.2.0
LUASYSLOG_SITE = $(call github,ntd,luasyslog,$(LUASYSLOG_VERSION))
LUASYSLOG_DEPENDENCIES = host-luarocks luainterpreter
LUASYSLOG_LICENSE = MIT
LUASYSLOG_LICENSE_FILES = COPYING
# fetching from github
# 0001-remove-AX_LUA_LIBS.patch touches configure.ac
LUASYSLOG_AUTORECONF = YES

$(eval $(autotools-package))
