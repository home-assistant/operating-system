################################################################################
#
# docker-containerd
#
################################################################################

DOCKER_CONTAINERD_VERSION = v1.0.2
DOCKER_CONTAINERD_COMMIT = cfd04396dc68220d1cecbe686a6cc3aa5ce3667c
DOCKER_CONTAINERD_SITE = $(call github,containerd,containerd,$(DOCKER_CONTAINERD_VERSION))
DOCKER_CONTAINERD_LICENSE = Apache-2.0
DOCKER_CONTAINERD_LICENSE_FILES = LICENSE.code

DOCKER_CONTAINERD_DEPENDENCIES = host-go

DOCKER_CONTAINERD_GOPATH = "$(@D)/gopath"
DOCKER_CONTAINERD_MAKE_ENV = $(HOST_GO_TARGET_ENV) \
	CGO_ENABLED=1 \
	GOBIN="$(@D)/bin" \
	GOPATH="$(DOCKER_CONTAINERD_GOPATH)"

DOCKER_CONTAINERD_GLDFLAGS = \
	-X github.com/containerd/containerd.GitCommit=$(DOCKER_CONTAINERD_COMMIT)

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
DOCKER_CONTAINERD_BUILD_TAGS += seccomp
DOCKER_CONTAINERD_DEPENDENCIES += libseccomp
endif

ifeq ($(BR2_PACKAGE_DOCKER_CONTAINERD_DRIVER_BTRFS),y)
DOCKER_CONTAINERD_DEPENDENCIES += btrfs-progs
else
DOCKER_CONTAINERD_BUILD_TAGS += no_btrfs
endif

ifeq ($(BR2_STATIC_LIBS),y)
DOCKER_CONTAINERD_GLDFLAGS += -extldflags '-static -fno-PIC'
DOCKER_CONTAINERD_BUILD_TAGS += static_build
DOCKER_CONTAINERD_BUILD_FLAGS += -buildmode pie
endif

define DOCKER_CONTAINERD_CONFIGURE_CMDS
	mkdir -p $(DOCKER_CONTAINERD_GOPATH)/src/github.com/containerd
	ln -s $(@D) $(DOCKER_CONTAINERD_GOPATH)/src/github.com/containerd/containerd
	mkdir -p $(DOCKER_CONTAINERD_GOPATH)/src/github.com/opencontainers
	ln -s $(RUNC_SRCDIR) $(DOCKER_CONTAINERD_GOPATH)/src/github.com/opencontainers/runc
endef

define DOCKER_CONTAINERD_BUILD_CMDS
	$(foreach d,ctr containerd containerd-shim,\
		cd $(DOCKER_CONTAINERD_GOPATH)/src/github.com/containerd/containerd; \
			$(DOCKER_CONTAINERD_MAKE_ENV) $(HOST_DIR)/bin/go build \
			-v -i -o $(@D)/bin/$(d) \
			-tags "$(DOCKER_CONTAINERD_BUILD_TAGS)" \
			-ldflags "$(DOCKER_CONTAINERD_GLDFLAGS)" \
			$(DOCKER_CONTAINERD_BUILD_FLAGS) \
			./cmd/$(d)$(sep)
	)
endef

define DOCKER_CONTAINERD_INSTALL_TARGET_CMDS
	ln -fs runc $(TARGET_DIR)/usr/bin/docker-runc
	$(INSTALL) -D -m 0755 $(@D)/bin/containerd $(TARGET_DIR)/usr/bin/docker-containerd
	$(INSTALL) -D -m 0755 $(@D)/bin/containerd-shim $(TARGET_DIR)/usr/bin/containerd-shim
	ln -fs containerd-shim $(TARGET_DIR)/usr/bin/docker-containerd-shim
endef

$(eval $(generic-package))
