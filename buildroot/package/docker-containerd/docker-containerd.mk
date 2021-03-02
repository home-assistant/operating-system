################################################################################
#
# docker-containerd
#
################################################################################

DOCKER_CONTAINERD_VERSION = 1.4.3
DOCKER_CONTAINERD_SITE = $(call github,containerd,containerd,v$(DOCKER_CONTAINERD_VERSION))
DOCKER_CONTAINERD_LICENSE = Apache-2.0
DOCKER_CONTAINERD_LICENSE_FILES = LICENSE
DOCKER_CONTAINERD_CPE_ID_VENDOR = linuxfoundation
DOCKER_CONTAINERD_CPE_ID_PRODUCT = containerd

DOCKER_CONTAINERD_GOMOD = github.com/containerd/containerd

DOCKER_CONTAINERD_LDFLAGS = \
	-X $(DOCKER_CONTAINERD_GOMOD)/version.Version=$(DOCKER_CONTAINERD_VERSION)

DOCKER_CONTAINERD_BUILD_TARGETS = \
	cmd/containerd \
	cmd/containerd-shim \
	cmd/containerd-shim-runc-v1 \
	cmd/containerd-shim-runc-v2 \
	cmd/ctr

DOCKER_CONTAINERD_INSTALL_BINS = $(notdir $(DOCKER_CONTAINERD_BUILD_TARGETS))

ifeq ($(BR2_PACKAGE_LIBAPPARMOR),y)
DOCKER_CONTAINERD_DEPENDENCIES += libapparmor
DOCKER_CONTAINERD_TAGS += apparmor
endif

ifeq ($(BR2_PACKAGE_LIBAPPARMOR),y)
DOCKER_CONTAINERD_DEPENDENCIES += libapparmor
DOCKER_CONTAINERD_TAGS += apparmor
endif

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
DOCKER_CONTAINERD_DEPENDENCIES += libseccomp host-pkgconf
DOCKER_CONTAINERD_TAGS += seccomp
endif

ifeq ($(BR2_PACKAGE_DOCKER_CONTAINERD_DRIVER_BTRFS),y)
DOCKER_CONTAINERD_DEPENDENCIES += btrfs-progs
else
DOCKER_CONTAINERD_TAGS += no_btrfs
endif

$(eval $(golang-package))
