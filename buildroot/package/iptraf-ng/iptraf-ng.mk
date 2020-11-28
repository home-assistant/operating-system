################################################################################
#
# iptraf-ng
#
################################################################################

IPTRAF_NG_VERSION = 1.2.1
IPTRAF_NG_SITE = $(call github,iptraf-ng,iptraf-ng,v$(IPTRAF_NG_VERSION))
IPTRAF_NG_LICENSE = GPL-2.0+
IPTRAF_NG_LICENSE_FILES = LICENSE
IPTRAF_NG_DEPENDENCIES = ncurses

define IPTRAF_NG_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		NCURSES_LDFLAGS="-lpanel -lncurses" \
		-C $(@D)
endef

define IPTRAF_NG_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		prefix=/usr DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
