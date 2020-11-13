################################################################################
#
# rustc
#
################################################################################

RUSTC_ARCH = $(call qstrip,$(BR2_PACKAGE_HOST_RUSTC_ARCH))
RUSTC_ABI = $(call qstrip,$(BR2_PACKAGE_HOST_RUSTC_ABI))

ifeq ($(BR2_PACKAGE_HOST_RUSTC_TARGET_ARCH_SUPPORTS),y)
RUSTC_TARGET_NAME = $(RUSTC_ARCH)-unknown-linux-gnu$(RUSTC_ABI)
endif

ifeq ($(HOSTARCH),x86)
RUSTC_HOST_ARCH = i686
else
RUSTC_HOST_ARCH = $(HOSTARCH)
endif

RUSTC_HOST_NAME = $(RUSTC_HOST_ARCH)-unknown-linux-gnu

$(eval $(host-virtual-package))

ifeq ($(BR2_PACKAGE_HOST_RUSTC_TARGET_ARCH_SUPPORTS),y)
define RUSTC_INSTALL_CARGO_CONFIG
	mkdir -p $(HOST_DIR)/share/cargo
	sed -e 's/@RUSTC_TARGET_NAME@/$(RUSTC_TARGET_NAME)/' \
		-e 's/@CROSS_PREFIX@/$(notdir $(TARGET_CROSS))/' \
		package/rustc/cargo-config.in \
		> $(HOST_DIR)/share/cargo/config
endef
# check-package disable TypoInPackageVariable - TOOLCHAIN intended
TOOLCHAIN_POST_INSTALL_STAGING_HOOKS += RUSTC_INSTALL_CARGO_CONFIG
endif
