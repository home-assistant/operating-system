################################################################################
#
# HassOS
#
################################################################################

SUPERVISOR_VERSION = 1.0.0
SUPERVISOR_LICENSE = Apache License 2.0
SUPERVISOR_LICENSE_FILES = $(BR2_EXTERNAL_HASSOS_PATH)/../LICENSE
SUPERVISOR_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/supervisor
SUPERVISOR_SITE_METHOD = local

define SUPERVISOR_BUILD_CMDS
	docker build --tag hassos-hostapps $(@D)/builder
endef

define SUPERVISOR_INSTALL_TARGET_CMDS
	docker run --rm --privileged \
		-e BUILDER_UID="$(shell id -u)" -e BUILDER_GID="$(shell id -g)" \
		-v $(BINARIES_DIR):/export \
		hassos-hostapps \
		--arch $(BR2_PACKAGE_SUPERVISOR_ARCH)
endef

$(eval $(generic-package))
