################################################################################
#
# Home Assistant tempio
#
################################################################################

TEMPIO_VERSION = 2021.09.0
TEMPIO_SITE = $(call github,home-assistant,tempio,$(TEMPIO_VERSION))
TEMPIO_LICENSE = Apache License 2.0
TEMPIO_LICENSE_FILES = LICENSE
TEMPIO_GOMOD = github.com/home-assistant/tempio
TEMPIO_LDFLAGS = -X main.version=$(TEMPIO_VERSION)

define TEMPIO_GO_VENDORING
	(cd $(@D); \
		$(HOST_DIR)/bin/go mod vendor)
endef

TEMPIO_POST_PATCH_HOOKS += TEMPIO_GO_VENDORING

$(eval $(golang-package))
$(eval $(host-golang-package))
