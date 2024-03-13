################################################################################
#
# xe-guest-utilities
#
################################################################################

XE_GUEST_UTILITIES_VERSION = 7.33.0
XE_GUEST_UTILITIES_SITE = $(call github,xenserver,xe-guest-utilities,v$(XE_GUEST_UTILITIES_VERSION))

XE_GUEST_UTILITIES_LICENSE = BSD-2-Clause
XE_GUEST_UTILITIES_LICENSE_FILES = LICENSE

XE_GUEST_UTILITIES_DEPENDENCIES = host-pkgconf

XE_GUEST_UTILITIES_XENSTORE_ALIAS = \
	xenstore-ls \
	xenstore-exists \
	xenstore-chmod \
	xenstore-rm \
	xenstore-read \
	xenstore-write \
	xenstore-watch \
	xenstore-list

define XE_GUEST_UTILITIES_BUILD_CMDS
	cd $(@D); \
	$(HOST_GO_TARGET_ENV) $(TARGET_MAKE_ENV); \
	$(XE_GUEST_UTILITIES_DL_ENV) $(GO_BIN) mod vendor; \
	$(MAKE)
endef

define XE_GUEST_UTILITIES_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/build/stage/usr/sbin/xe-linux-distribution \
		$(TARGET_DIR)/usr/sbin/xe-linux-distribution
	$(INSTALL) -m 755 $(@D)/build/stage/usr/sbin/xe-daemon \
		$(TARGET_DIR)/usr/sbin/xe-daemon

	$(INSTALL) -m 755 $(@D)/build/stage/usr/bin/xenstore \
		$(TARGET_DIR)/usr/bin/xenstore

	$(foreach f,$(XE_GUEST_UTILITIES_XENSTORE_ALIAS), \
		ln -sf xenstore $(TARGET_DIR)/usr/bin/$(f)
	)

	$(INSTALL) -D -m 644 $(@D)/mk/xen-vcpu-hotplug.rules \
		$(TARGET_DIR)/usr/lib/udev/rules.d/10-xen-vcpu-hotplug.rules
endef

define XE_GUEST_UTILITIES_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(XE_GUEST_UTILITIES_PKGDIR)/proc-xen.mount \
		$(TARGET_DIR)/usr/lib/systemd/system/proc-xen.mount
	$(INSTALL) -D -m 0644 $(XE_GUEST_UTILITIES_PKGDIR)/tmpfile.conf \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/30-xenstored.conf

	$(INSTALL) -D -m 0644 $(XE_GUEST_UTILITIES_PKGDIR)/xe-daemon.service \
		$(TARGET_DIR)/usr/lib/systemd/system/xe-daemon.service
endef

$(eval $(golang-package))
