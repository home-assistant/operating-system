include $(sort $(wildcard $(BR2_EXTERNAL_HASSOS_PATH)/package/*/*.mk))

.PHONY: linux-check-dotconfig
linux-check-dotconfig: linux-check-configuration-done
	CC=$(TARGET_CC) LD=$(TARGET_LD) srctree=$(LINUX_SRCDIR) \
	ARCH=$(if $(BR2_x86_64),x86,$(if $(BR2_aarch64),arm64,$(ARCH))) \
	SRCARCH=$(if $(BR2_x86_64),x86,$(if $(BR2_aarch64),arm64,$(ARCH))) \
	 $(BR2_EXTERNAL_HASSOS_PATH)/scripts/check-dotconfig.py \
		$(BR2_CHECK_DOTCONFIG_OPTS) \
		--src-kconfig $(LINUX_SRCDIR)Kconfig \
		--actual-config $(LINUX_SRCDIR).config \
		$(shell echo $(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE) $(BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES))
