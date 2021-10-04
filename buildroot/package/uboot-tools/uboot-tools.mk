################################################################################
#
# uboot-tools
#
################################################################################

UBOOT_TOOLS_VERSION = 2020.04
UBOOT_TOOLS_SOURCE = u-boot-$(UBOOT_TOOLS_VERSION).tar.bz2
UBOOT_TOOLS_SITE = ftp://ftp.denx.de/pub/u-boot
UBOOT_TOOLS_LICENSE = GPL-2.0+
UBOOT_TOOLS_LICENSE_FILES = Licenses/gpl-2.0.txt
UBOOT_TOOLS_CPE_ID_VENDOR = denx
UBOOT_TOOLS_CPE_ID_PRODUCT = u-boot
UBOOT_TOOLS_INSTALL_STAGING = YES

# u-boot 2020.01+ needs make 4.0+
UBOOT_TOOLS_DEPENDENCIES = $(BR2_MAKE_HOST_DEPENDENCY)
HOST_UBOOT_TOOLS_DEPENDENCIES = $(BR2_MAKE_HOST_DEPENDENCY)

define UBOOT_TOOLS_CONFIGURE_CMDS
	mkdir -p $(@D)/include/config
	touch $(@D)/include/config/auto.conf
endef

UBOOT_TOOLS_MAKE_OPTS = CROSS_COMPILE="$(TARGET_CROSS)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	HOSTCFLAGS="$(HOST_CFLAGS)" \
	STRIP=$(TARGET_STRIP)

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_FIT_SUPPORT),y)
UBOOT_TOOLS_MAKE_OPTS += CONFIG_FIT=y CONFIG_MKIMAGE_DTC_PATH=dtc
UBOOT_TOOLS_DEPENDENCIES += dtc
endif

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_FIT_SIGNATURE_SUPPORT),y)
UBOOT_TOOLS_MAKE_OPTS += CONFIG_FIT_SIGNATURE=y CONFIG_FIT_SIGNATURE_MAX_SIZE=0x10000000
UBOOT_TOOLS_DEPENDENCIES += openssl host-pkgconf
endif

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_FIT_CHECK_SIGN),y)
define UBOOT_TOOLS_INSTALL_FIT_CHECK_SIGN
	$(INSTALL) -m 0755 -D $(@D)/tools/fit_check_sign $(TARGET_DIR)/usr/bin/fit_check_sign
endef
endif

define UBOOT_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(BR2_MAKE) -C $(@D) $(UBOOT_TOOLS_MAKE_OPTS) \
		CROSS_BUILD_TOOLS=y tools-only
	$(TARGET_MAKE_ENV) $(BR2_MAKE) -C $(@D) $(UBOOT_TOOLS_MAKE_OPTS) \
		envtools no-dot-config-targets=envtools
endef

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_MKIMAGE),y)
define UBOOT_TOOLS_INSTALL_MKIMAGE
	$(INSTALL) -m 0755 -D $(@D)/tools/mkimage $(TARGET_DIR)/usr/bin/mkimage
endef
endif

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_MKENVIMAGE),y)
define UBOOT_TOOLS_INSTALL_MKENVIMAGE
	$(INSTALL) -m 0755 -D $(@D)/tools/mkenvimage $(TARGET_DIR)/usr/bin/mkenvimage
endef
endif

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_FWPRINTENV),y)
define UBOOT_TOOLS_INSTALL_FWPRINTENV
	$(INSTALL) -m 0755 -D $(@D)/tools/env/fw_printenv $(TARGET_DIR)/usr/sbin/fw_printenv
	ln -sf fw_printenv $(TARGET_DIR)/usr/sbin/fw_setenv
endef
endif

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_DUMPIMAGE),y)
define UBOOT_TOOLS_INSTALL_DUMPIMAGE
	$(INSTALL) -m 0755 -D $(@D)/tools/dumpimage $(TARGET_DIR)/usr/sbin/dumpimage
endef
endif

define UBOOT_TOOLS_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tools/env/lib.a $(STAGING_DIR)/usr/lib/libubootenv.a
	$(INSTALL) -D -m 0644 $(@D)/tools/env/fw_env.h $(STAGING_DIR)/usr/include/fw_env.h
endef

define UBOOT_TOOLS_INSTALL_TARGET_CMDS
	$(UBOOT_TOOLS_INSTALL_MKIMAGE)
	$(UBOOT_TOOLS_INSTALL_MKENVIMAGE)
	$(UBOOT_TOOLS_INSTALL_FWPRINTENV)
	$(UBOOT_TOOLS_INSTALL_DUMPIMAGE)
	$(UBOOT_TOOLS_INSTALL_FIT_CHECK_SIGN)
endef

# host-uboot-tools

define HOST_UBOOT_TOOLS_CONFIGURE_CMDS
	mkdir -p $(@D)/include/config
	touch $(@D)/include/config/auto.conf
endef

HOST_UBOOT_TOOLS_MAKE_OPTS = HOSTCC="$(HOSTCC)" \
	HOSTCFLAGS="$(HOST_CFLAGS)" \
	HOSTLDFLAGS="$(HOST_LDFLAGS)"

ifeq ($(BR2_PACKAGE_HOST_UBOOT_TOOLS_FIT_SUPPORT),y)
HOST_UBOOT_TOOLS_MAKE_OPTS += CONFIG_FIT=y CONFIG_MKIMAGE_DTC_PATH=dtc
HOST_UBOOT_TOOLS_DEPENDENCIES += host-dtc
endif

ifeq ($(BR2_PACKAGE_HOST_UBOOT_TOOLS_FIT_SIGNATURE_SUPPORT),y)
HOST_UBOOT_TOOLS_MAKE_OPTS += CONFIG_FIT_SIGNATURE=y CONFIG_FIT_SIGNATURE_MAX_SIZE=0x10000000
HOST_UBOOT_TOOLS_DEPENDENCIES += host-openssl
endif

ifeq ($(BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE),y)

UBOOT_TOOLS_GENERATE_ENV_FILE = $(call qstrip,$(BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SOURCE))

# If BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SOURCE is left empty, we
# will use the default environment provided in the U-Boot build
# directory as boot-env-defaults.txt, which requires having uboot as a
# dependency.
# If BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SOURCE is not empty, is
# might be referring to a file within the U-Boot source tree, so we
# also need to have uboot as a dependency.
ifeq ($(BR2_TARGET_UBOOT),y)
HOST_UBOOT_TOOLS_DEPENDENCIES += uboot

# Handle the case where BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SOURCE
# is left empty, use the default U-Boot environment.
ifeq ($(UBOOT_TOOLS_GENERATE_ENV_FILE),)
UBOOT_TOOLS_GENERATE_ENV_FILE = $(@D)/boot-env-defaults.txt
define HOST_UBOOT_TOOLS_GENERATE_ENV_DEFAULTS
	CROSS_COMPILE="$(TARGET_CROSS)" \
		$(UBOOT_SRCDIR)/scripts/get_default_envs.sh \
		$(UBOOT_SRCDIR) \
		> $(UBOOT_TOOLS_GENERATE_ENV_FILE)
endef
endif # UBOOT_TOOLS_GENERATE_ENV_FILE
endif # BR2_TARGET_UBOOT

ifeq ($(BR_BUILDING),y)
ifeq ($(call qstrip,$(BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SIZE)),)
$(error Please provide U-Boot environment size (BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SIZE setting))
endif
# If U-Boot is not available, ENVIMAGE_SOURCE must be provided by user,
# otherwise it is optional because the default can be taken from U-Boot
ifeq ($(BR2_TARGET_UBOOT),)
ifeq ($(call qstrip,$(BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SOURCE)),)
$(error Please provide U-Boot environment file (BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SOURCE setting))
endif
endif #BR2_TARGET_UBOOT
endif #BR_BUILDING

define HOST_UBOOT_TOOLS_GENERATE_ENVIMAGE
	$(HOST_UBOOT_TOOLS_GENERATE_ENV_DEFAULTS)
	cat $(UBOOT_TOOLS_GENERATE_ENV_FILE) | \
		$(@D)/tools/mkenvimage -s $(BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SIZE) \
		$(if $(BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_REDUNDANT),-r) \
		$(if $(filter "BIG",$(BR2_ENDIAN)),-b) \
		-o $(@D)/tools/uboot-env.bin \
		-
endef
define HOST_UBOOT_TOOLS_INSTALL_ENVIMAGE
	$(INSTALL) -m 0755 -D $(@D)/tools/uboot-env.bin $(BINARIES_DIR)/uboot-env.bin
endef
endif #BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE

ifeq ($(BR2_PACKAGE_HOST_UBOOT_TOOLS_BOOT_SCRIPT),y)
ifeq ($(BR_BUILDING),y)
ifeq ($(call qstrip,$(BR2_PACKAGE_HOST_UBOOT_TOOLS_BOOT_SCRIPT_SOURCE)),)
$(error Please define a source file for U-Boot boot script (BR2_PACKAGE_HOST_UBOOT_TOOLS_BOOT_SCRIPT_SOURCE setting))
endif
endif #BR_BUILDING

define HOST_UBOOT_TOOLS_GENERATE_BOOT_SCRIPT
	$(@D)/tools/mkimage -C none -A $(MKIMAGE_ARCH) -T script \
		-d $(call qstrip,$(BR2_PACKAGE_HOST_UBOOT_TOOLS_BOOT_SCRIPT_SOURCE)) \
		$(@D)/tools/boot.scr
endef
define HOST_UBOOT_TOOLS_INSTALL_BOOT_SCRIPT
	$(INSTALL) -m 0755 -D $(@D)/tools/boot.scr $(BINARIES_DIR)/boot.scr
endef
endif #BR2_PACKAGE_HOST_UBOOT_TOOLS_BOOT_SCRIPT

define HOST_UBOOT_TOOLS_BUILD_CMDS
	$(BR2_MAKE1) -C $(@D) $(HOST_UBOOT_TOOLS_MAKE_OPTS) tools-only
	$(HOST_UBOOT_TOOLS_GENERATE_ENVIMAGE)
	$(HOST_UBOOT_TOOLS_GENERATE_BOOT_SCRIPT)
endef

define HOST_UBOOT_TOOLS_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/tools/mkimage $(HOST_DIR)/bin/mkimage
	$(INSTALL) -m 0755 -D $(@D)/tools/mkenvimage $(HOST_DIR)/bin/mkenvimage
	$(INSTALL) -m 0755 -D $(@D)/tools/dumpimage $(HOST_DIR)/bin/dumpimage
	$(HOST_UBOOT_TOOLS_INSTALL_ENVIMAGE)
	$(HOST_UBOOT_TOOLS_INSTALL_BOOT_SCRIPT)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))

# Convenience variables for other mk files that make use of mkimage

MKIMAGE = $(HOST_DIR)/bin/mkimage

# mkimage supports alpha arc arm arm64 blackfin ia64 invalid m68k microblaze mips mips64 nds32 nios2 or1k powerpc riscv s390 sandbox sh sparc sparc64 x86 x86_64 xtensa
# KERNEL_ARCH can be arm64 arc arm blackfin m68k microblaze mips nios2 powerpc sh sparc i386 x86_64 xtensa
# For i386, we need to convert
# For openrisc, we need to convert
# For others, we'll just keep KERNEL_ARCH
ifeq ($(KERNEL_ARCH),i386)
MKIMAGE_ARCH = x86
else ifeq ($(KERNEL_ARCH),openrisc)
MKIMAGE_ARCH = or1k
else
MKIMAGE_ARCH = $(KERNEL_ARCH)
endif
