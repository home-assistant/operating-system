################################################################################
#
# quazip
#
################################################################################

QUAZIP_VERSION = 1.1
QUAZIP_SITE = $(call github,stachenov,quazip,v$(QUAZIP_VERSION))
QUAZIP_INSTALL_STAGING = YES
QUAZIP_DEPENDENCIES = \
	zlib \
	qt5base
QUAZIP_LICENSE = LGPL-2.1
QUAZIP_LICENSE_FILES = COPYING

$(eval $(cmake-package))
