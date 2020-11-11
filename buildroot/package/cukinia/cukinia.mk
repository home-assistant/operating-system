################################################################################
#
# cukinia
#
################################################################################

CUKINIA_VERSION = 0.5.1
CUKINIA_SITE = $(call github,savoirfairelinux,cukinia,v$(CUKINIA_VERSION))
CUKINIA_LICENSE = Apache-2.0 or GPL-3.0
CUKINIA_LICENSE_FILES = LICENSE LICENSE.GPLv3

define CUKINIA_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/cukinia $(TARGET_DIR)/usr/bin/cukinia
	$(INSTALL) -D -m 0644 $(CUKINIA_PKGDIR)/cukinia.conf \
		$(TARGET_DIR)/etc/cukinia/cukinia.conf
endef

$(eval $(generic-package))
