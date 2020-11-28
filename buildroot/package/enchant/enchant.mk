################################################################################
#
# enchant
#
################################################################################

ENCHANT_VERSION = 2.2.11
ENCHANT_SITE = \
	https://github.com/AbiWord/enchant/releases/download/v$(ENCHANT_VERSION)
ENCHANT_INSTALL_STAGING = YES
ENCHANT_DEPENDENCIES = libglib2 host-pkgconf
ENCHANT_LICENSE = LGPL-2.1+
ENCHANT_LICENSE_FILES = COPYING.LIB

$(eval $(autotools-package))
