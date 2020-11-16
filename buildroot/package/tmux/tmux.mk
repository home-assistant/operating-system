################################################################################
#
# tmux
#
################################################################################

TMUX_VERSION = 2.9a
TMUX_SITE = https://github.com/tmux/tmux/releases/download/$(TMUX_VERSION)
TMUX_LICENSE = ISC
TMUX_LICENSE_FILES = COPYING
TMUX_DEPENDENCIES = libevent ncurses host-pkgconf

# 0001-Do-not-write-after-the-end-of-the-array-and-overwrit.patch
TMUX_IGNORE_CVES += CVE-2020-27347

# Add /usr/bin/tmux to /etc/shells otherwise some login tools like dropbear
# can reject the user connection. See man shells.
define TMUX_ADD_TMUX_TO_SHELLS
	grep -qsE '^/usr/bin/tmux$$' $(TARGET_DIR)/etc/shells \
		|| echo "/usr/bin/tmux" >> $(TARGET_DIR)/etc/shells
endef
TMUX_TARGET_FINALIZE_HOOKS += TMUX_ADD_TMUX_TO_SHELLS

$(eval $(autotools-package))
