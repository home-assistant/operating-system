################################################################################
#
# hassio
#
################################################################################

HASSIO_VERSION = 1.0.0
HASSIO_LICENSE = Apache License 2.0
HASSIO_LICENSE_FILES = $(BR2_EXTERNAL_HASSIO_PATH)/../LICENSE
HASSIO_SITE = $(BR2_EXTERNAL_HASSIO_PATH)/package/hassio
HASSIO_SITE_METHOD = local

define HASSIO_BUILD_CMDS
	docker build --tag hassio-hostapps $(@D)/builder
endef

define HASSIO_INSTALL_TARGET_CMDS
	docker run --rm --privileged \
		-v $(BINARIES_DIR):/export \
		-v $(BR2_EXTERNAL_HASSIO_PATH)/apparmor:/apparmor \
		hassio-hostapps \
		--supervisor $(BR2_PACKAGE_HASSIO_SUPERVISOR) \
		--supervisor-version $(BR2_PACKAGE_HASSIO_SUPERVISOR_VERSION) \
		--supervisor-args $(BR2_PACKAGE_HASSIO_SUPERVISOR_ARGS) \
		--supervisor-profile $(BR2_PACKAGE_HASSIO_SUPERVISOR_PROFILE) \
		--cli $(BR2_PACKAGE_HASSIO_CLI) \
		--cli-version $(BR2_PACKAGE_HASSIO_CLI_VERSION) \
		--cli-args $(BR2_PACKAGE_HASSIO_CLI_ARGS) \
		--cli-profile $(BR2_PACKAGE_HASSIO_CLI_PROFILE) \
		--apparmor $(BR2_PACKAGE_HASSIO_APPARMOR_DIR)
endef

$(eval $(generic-package))
