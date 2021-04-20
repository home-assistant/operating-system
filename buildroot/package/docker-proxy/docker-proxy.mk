################################################################################
#
# docker-proxy
#
################################################################################

DOCKER_PROXY_VERSION = b3507428be5b458cb0e2b4086b13531fb0706e46
DOCKER_PROXY_SITE = $(call github,moby,libnetwork,$(DOCKER_PROXY_VERSION))

DOCKER_PROXY_LICENSE = Apache-2.0
DOCKER_PROXY_LICENSE_FILES = LICENSE

DOCKER_PROXY_DEPENDENCIES = host-pkgconf

DOCKER_PROXY_BUILD_TARGETS = cmd/proxy

define DOCKER_PROXY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/proxy $(TARGET_DIR)/usr/bin/docker-proxy
endef

$(eval $(golang-package))
