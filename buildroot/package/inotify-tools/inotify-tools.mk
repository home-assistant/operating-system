################################################################################
#
# inotify-tools
#
################################################################################

INOTIFY_TOOLS_VERSION = 3.20.2.2
INOTIFY_TOOLS_SITE = https://github.com/inotify-tools/inotify-tools/releases/download/$(INOTIFY_TOOLS_VERSION)
INOTIFY_TOOLS_LICENSE = GPL-2.0+
INOTIFY_TOOLS_LICENSE_FILES = COPYING
INOTIFY_TOOLS_INSTALL_STAGING = YES

$(eval $(autotools-package))
