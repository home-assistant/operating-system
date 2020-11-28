################################################################################
#
# open2300
#
################################################################################

OPEN2300_VERSION = f21982e0b1f8321561e5ad1668307fde97700e1b
OPEN2300_SITE = $(call github,wezm,open2300,$(OPEN2300_VERSION))
OPEN2300_LICENSE = GPL-2.0
OPEN2300_LICENSE_FILES = COPYING

OPEN2300_BINS = \
	open2300 dump2300 log2300 fetch2300 wu2300 cw2300 history2300 \
	histlog2300 bin2300 xml2300 light2300 interval2300 minmax2300
OPEN2300_CFLAGS = $(TARGET_CFLAGS)
OPEN2300_LDFLAGS = $(TARGET_LDFLAGS)

ifeq ($(BR2_PACKAGE_MYSQL),y)
OPEN2300_DEPENDENCIES += mysql
OPEN2300_BINS += mysql2300 mysqlhistlog2300
OPEN2300_CFLAGS += $(shell $(STAGING_DIR)/usr/bin/mysql_config --cflags)
OPEN2300_LDFLAGS += $(shell $(STAGING_DIR)/usr/bin/mysql_config --libs)
endif

define OPEN2300_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" \
		CFLAGS="$(OPEN2300_CFLAGS)" CC_LDFLAGS="$(OPEN2300_LDFLAGS)" \
		-C $(@D) $(OPEN2300_BINS)
endef

define OPEN2300_INSTALL_TARGET_CMDS
	for prog in $(OPEN2300_BINS); do \
		$(INSTALL) -D -m 0755 $(@D)/$$prog $(TARGET_DIR)/usr/bin/$$prog ; \
	done
endef

$(eval $(generic-package))
