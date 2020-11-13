################################################################################
#
# altera-stapl
#
################################################################################

ALTERA_STAPL_VERSION = 0.3.3
ALTERA_STAPL_SITE = $(call github,kontron,altera-stapl,$(ALTERA_STAPL_VERSION))
ALTERA_STAPL_LICENSE = GPLv2+
ALTERA_STAPL_LICENSE_FILES = COPYING
ALTERA_STAPL_DEPENDENCIES = libgpiod

define ALTERA_STAPL_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define ALTERA_STAPL_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
