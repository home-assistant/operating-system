LINUX_GADGET_VERSION = 0.99.0
LINUX_GADGET_LICENSE = Apache License 2.0
LINUX_GADGET_LICENSE_FILES = $(BR2_EXTERNAL_HASSOS_PATH)/../LICENSE
LINUX_GADGET_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/linux-gadget
LINUX_GADGET_SITE_METHOD = local

ifneq ($(BR2_PACKAGE_LINUX_GADGET_GETTY),y)
LINUX_GADGET_MOD = "g_mass_storage"
else ifneq ($(BR2_PACKAGE_LINUX_GADGET_UMS),y)
LINUX_GADGET_MOD = "g_serial"
else
LINUX_GADGET_MOD = "g_acm_ms"
endif

ifeq ($(BR2_PACKAGE_LINUX_GADGET_UMS),y)
LINUX_GADGET_OPT = "file=$(BR2_PACKAGE_LINUX_GADGET_UMS_LUN)"
endif

define LINUX_GADGET_BUILD_CMDS
	echo $(LINUX_GADGET_MOD) > $(@D)/gadget.conf
	if [[ -n $(LINUX_GADGET_OPT) ]]; then \
		echo $(LINUX_GADGET_OPT) > $(@D)/gadget_opt.conf; \
	fi
endef

define LINUX_GADGET_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/gadget.conf \
		$(TARGET_DIR)/etc/modules-load.d/gadget.conf

	if [ "$(BR2_PACKAGE_LINUX_GADGET_GETTY)" = "y" ]; then \
		$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/getty.target.wants; \
		ln -fs "/usr/lib/systemd/system/serial-getty@.service" \
			"$(TARGET_DIR)/etc/systemd/system/getty.target.wants/serial-getty@ttyGS0.service"; \
	fi

	if [[ -n $(LINUX_GADGET_OPT) ]]; then \
		$(INSTALL) -m 0644 -D $(@D)/gadget_opt.conf \
			$(TARGET_DIR)/etc/modprobe.d/gadget.conf; \
	fi
endef

$(eval $(generic-package))
