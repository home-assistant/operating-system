################################################################################
#
# docker-containerd
#
################################################################################

DOCKER_CONTAINERD_VERSION = v1.1.0
DOCKER_CONTAINERD_SITE = $(call github,containerd,containerd,$(DOCKER_CONTAINERD_VERSION))
DOCKER_CONTAINERD_LICENSE = Apache-2.0
DOCKER_CONTAINERD_LICENSE_FILES = LICENSE.code

DOCKER_CONTAINERD_BUILD_TARGETS = cmd/ctr cmd/containerd cmd/containerd-shim
DOCKER_CONTAINERD_TAGS = apparmor no_btrfs

DOCKER_CONTAINERD_INSTALL_BINS = containerd containerd-shim

define DOCKER_CONTAINERD_INSTALL_SYMLINKS
	ln -fs runc $(TARGET_DIR)/usr/bin/docker-runc
	ln -fs containerd $(TARGET_DIR)/usr/bin/docker-containerd
	ln -fs containerd-shim $(TARGET_DIR)/usr/bin/docker-containerd-shim
endef

DOCKER_CONTAINERD_POST_INSTALL_TARGET_HOOKS += DOCKER_CONTAINERD_INSTALL_SYMLINKS

$(eval $(golang-package))
