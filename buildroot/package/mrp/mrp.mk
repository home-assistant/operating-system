################################################################################
#
# mrp
#
################################################################################

MRP_VERSION = 1.1
MRP_SITE = $(call github,microchip-ung,mrp,v$(MRP_VERSION))
MRP_DEPENDENCIES = libev libmnl libnl
MRP_LICENSE = GPL-2.0
MRP_LICENSE_FILES = LICENSE

define MRP_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(MRP_PKGDIR)/S65mrp \
		$(TARGET_DIR)/etc/init.d/S65mrp
endef

define MRP_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(MRP_PKGDIR)/mrp.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mrp.service
endef

$(eval $(cmake-package))
