################################################################################
#
# hassio
#
################################################################################

HASSIO_VERSION = 0.1
HASSIO_LICENSE = Apache License 2.0
HASSIO_LICENSE_FILES = $(BR2_EXTERNAL_HASSIO_PATH)/../LICENSE
HASSIO_SITE = $(BR2_EXTERNAL_HASSIO_PATH)/package/hassio

define HASSIO_BUILD_CMDS
	docker build --tag hassio-hostapps $(@D)/builder
endef

define HASSIO_INSTALL_TARGET_CMDS
	docker run --rm --privileged -v ${BINARIES_DIR}:/export hassio-hostapps \
		--supervisor ${BR2_PACKAGE_HASSIO_SUPERVISOR} \
		--supervisor-version ${BR2_PACKAGE_HASSIO_SUPERVISOR_VERSION} \
		--supervisor-args ${BR2_PACKAGE_HASSIO_SUPERVISOR_ARGS} \
		--cli ${BR2_PACKAGE_HASSIO_CLI} \
		--cli-version ${BR2_PACKAGE_HASSIO_CLI_VERSION} \
		--cli-args ${BR2_PACKAGE_HASSIO_CLI_ARGS}
endef

$(eval $(generic-package))
