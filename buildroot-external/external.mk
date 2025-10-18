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

# if cpu microcode is required we embed it into the kernel build
ifeq ($(or $(BR2_PACKAGE_INTEL_MICROCODE),$(BR2_PACKAGE_LINUX_FIRMWARE_AMD_UCODE)),y)
ifneq ($(BR2_PACKAGE_INTEL_MICROCODE)$(BR2_PACKAGE_LINUX_FIRMWARE_AMD_UCODE),)

UCODE_FRAG := $(BINARIES_DIR)/linux-ucode.fragment

# Hook: Generate fragment before kernel configuration
define GEN_UCODE_FRAGMENT
	@echo ">> Generating $(UCODE_FRAG)"
	@mkdir -p $(BINARIES_DIR)
	@{ \
		echo 'CONFIG_EXTRA_FIRMWARE_DIR="$(BINARIES_DIR)"'; \
		printf 'CONFIG_EXTRA_FIRMWARE="'; \
		( cd $(BINARIES_DIR) 2>/dev/null && \
		  find intel-ucode amd-ucode -type f \! -name "*README*" \! -name "*.asc" -printf '%p ' 2>/dev/null || true ); \
		echo '"'; \
	} > $(UCODE_FRAG)
endef

LINUX_PRE_PATCH_HOOKS += GEN_UCODE_FRAGMENT
LINUX_KCONFIG_FRAGMENT_FILES += $(UCODE_FRAG)

endif
