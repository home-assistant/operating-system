################################################################################
#
# pdmenu
#
################################################################################

PDMENU_VERSION = 1.3.6
PDMENU_SITE = https://git.joeyh.name/index.cgi/pdmenu.git/snapshot
PDMENU_LICENSE = GPL-2.0
PDMENU_LICENSE_FILES = doc/COPYING
PDMENU_DEPENDENCIES = slang $(TARGET_NLS_DEPENDENCIES)
PDMENU_INSTALL_TARGET_OPTS = INSTALL_PREFIX=$(TARGET_DIR) install

$(eval $(autotools-package))
