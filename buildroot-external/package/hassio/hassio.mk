################################################################################
#
# HAOS
#
################################################################################

HASSIO_VERSION = 1.0.0
HASSIO_LICENSE = Apache License 2.0
HASSIO_LICENSE_FILES = $(BR2_EXTERNAL_HASSOS_PATH)/../LICENSE
HASSIO_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/hassio
HASSIO_SITE_METHOD = local

define HASSIO_BUILD_CMDS
	docker build --tag hassos-hostapps $(@D)/builder
endef

define HASSIO_INSTALL_TARGET_CMDS
	docker run --rm --privileged \
		-e BUILDER_UID="$(shell id -u)" -e BUILDER_GID="$(shell id -g)" \
		-v $(BINARIES_DIR):/export \
		hassos-hostapps \
		--arch $(BR2_PACKAGE_HASSIO_ARCH) \
		--machine $(BR2_PACKAGE_HASSIO_MACHINE)
endef

$(eval $(generic-package))
