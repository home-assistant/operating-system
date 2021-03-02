################################################################################
#
# ply
#
################################################################################

PLY_VERSION = 2.1.1
PLY_SITE = $(call github,wkz,ply,$(PLY_VERSION))
PLY_AUTORECONF = YES
PLY_LICENSE = GPL-2.0
PLY_LICENSE_FILES = COPYING
PLY_INSTALL_STAGING = YES
PLY_DEPENDENCIES = host-flex host-bison

$(eval $(autotools-package))
