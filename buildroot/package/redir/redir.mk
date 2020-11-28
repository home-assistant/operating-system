################################################################################
#
# redir
#
################################################################################

REDIR_VERSION = 3.3
REDIR_SOURCE = redir-$(REDIR_VERSION).tar.xz
REDIR_SITE = https://github.com/troglobit/redir/releases/download/v$(REDIR_VERSION)
REDIR_LICENSE = GPL-2.0+
REDIR_LICENSE_FILES = COPYING
REDIR_CONF_OPTS = \
	--disable-compat \
	--enable-shaper \
	--enable-ftp

$(eval $(autotools-package))
