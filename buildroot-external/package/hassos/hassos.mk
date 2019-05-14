################################################################################
#
# HassOS
#
################################################################################

HASSOS_VERSION = 1.0.0
HASSOS_LICENSE = Apache License 2.0
HASSOS_LICENSE_FILES = $(BR2_EXTERNAL_HASSOS_PATH)/../LICENSE
HASSOS_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/hassos
HASSOS_SITE_METHOD = local

define HASSOS_BUILD_CMDS
	docker build --tag hassos-hostapps $(@D)/builder
endef

define HASSOS_INSTALL_TARGET_CMDS
	docker run --rm --privileged \
		-e BUILDER_UID="$(shell id -u)" -e BUILDER_GID="$(shell id -g)" \
		-v $(BINARIES_DIR):/export \
		hassos-hostapps \
		--supervisor $(BR2_PACKAGE_HASSOS_SUPERVISOR) \
		--supervisor-version $(BR2_PACKAGE_HASSOS_SUPERVISOR_VERSION) \
		--supervisor-args $(BR2_PACKAGE_HASSOS_SUPERVISOR_ARGS) \
		--supervisor-profile $(BR2_PACKAGE_HASSOS_SUPERVISOR_PROFILE) \
		--supervisor-profile-url $(BR2_PACKAGE_HASSOS_SUPERVISOR_PROFILE_URL) \
		--cli $(BR2_PACKAGE_HASSOS_CLI) \
		--cli-version $(BR2_PACKAGE_HASSOS_CLI_VERSION) \
		--cli-args $(BR2_PACKAGE_HASSOS_CLI_ARGS) \
		--cli-profile $(BR2_PACKAGE_HASSOS_CLI_PROFILE) \
		--cli-profile-url $(BR2_PACKAGE_HASSOS_CLI_PROFILE_URL) \
		--apparmor $(BR2_PACKAGE_HASSOS_APPARMOR_DIR)
endef

$(eval $(generic-package))
