################################################################################
#
# bitwise
#
################################################################################

BITWISE_VERSION = 0.41
BITWISE_SITE = https://github.com/mellowcandle/bitwise/releases/download/v$(BITWISE_VERSION)
BITWISE_SOURCE = bitwise-v$(BITWISE_VERSION).tar.gz
BITWISE_DEPENDENCIES = ncurses readline
BITWISE_LICENSE = GPL-3.0
BITWISE_LICENSE_FILES = COPYING

$(eval $(autotools-package))
