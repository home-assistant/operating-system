################################################################################
#
# fuse-overlayfs
#
################################################################################

FUSE_OVERLAYFS_VERSION = 1.2.0
FUSE_OVERLAYFS_SITE = $(call github,containers,fuse-overlayfs,v$(FUSE_OVERLAYFS_VERSION))
FUSE_OVERLAYFS_LICENSE = GPL-3.0
FUSE_OVERLAYFS_LICENSE_FILES = COPYING

FUSE_OVERLAYFS_AUTORECONF = YES
FUSE_OVERLAYFS_DEPENDENCIES = libfuse3 host-pkgconf

$(eval $(autotools-package))
