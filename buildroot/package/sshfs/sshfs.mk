################################################################################
#
# sshfs
#
################################################################################

SSHFS_VERSION = 3.7.1
SSHFS_SOURCE = sshfs-$(SSHFS_VERSION).tar.xz
SSHFS_SITE = https://github.com/libfuse/sshfs/releases/download/sshfs-$(SSHFS_VERSION)
SSHFS_LICENSE = GPL-2.0
SSHFS_LICENSE_FILES = COPYING
SSHFS_DEPENDENCIES = \
	libglib2 libfuse3 openssh \
	$(TARGET_NLS_DEPENDENCIES) \
	$(if $(BR2_ENABLE_LOCALE),,libiconv)

$(eval $(meson-package))
