################################################################################
#
# grub2
#
################################################################################

GRUB2_VERSION = 2.04
GRUB2_SITE = http://ftp.gnu.org/gnu/grub
GRUB2_SOURCE = grub-$(GRUB2_VERSION).tar.xz
GRUB2_LICENSE = GPL-3.0+
GRUB2_LICENSE_FILES = COPYING
GRUB2_DEPENDENCIES = host-bison host-flex host-grub2
HOST_GRUB2_DEPENDENCIES = host-bison host-flex
GRUB2_INSTALL_IMAGES = YES

# 0001-build-Fix-GRUB-i386-pc-build-with-Ubuntu-gcc.patch and 2021/03/02
# security fixes (patches 0029-0149)
define GRUB2_AVOID_AUTORECONF
	$(Q)touch $(@D)/Makefile.util.am
	$(Q)touch $(@D)/aclocal.m4
	$(Q)touch $(@D)/Makefile.in
	$(Q)touch $(@D)/configure
endef
GRUB2_POST_PATCH_HOOKS += GRUB2_AVOID_AUTORECONF
HOST_GRUB2_POST_PATCH_HOOKS += GRUB2_AVOID_AUTORECONF

# 0002-yylex-Make-lexer-fatal-errors-actually-be-fatal.patch
GRUB2_IGNORE_CVES += CVE-2020-10713
# 0005-calloc-Use-calloc-at-most-places.patch
GRUB2_IGNORE_CVES += CVE-2020-14308
# 0006-malloc-Use-overflow-checking-primitives-where-we-do-.patch
GRUB2_IGNORE_CVES += CVE-2020-14309 CVE-2020-14310 CVE-2020-14311
# 0019-script-Avoid-a-use-after-free-when-redefining-a-func.patch
GRUB2_IGNORE_CVES += CVE-2020-15706
# 0028-linux-Fix-integer-overflows-in-initrd-size-handling.patch
GRUB2_IGNORE_CVES += CVE-2020-15707
# 2021/03/02 security fixes - patches 0029-0149
GRUB2_IGNORE_CVES += CVE-2020-25632 CVE-2020-25647 CVE-2020-27749 \
	CVE-2020-27779 CVE-2021-3418 CVE-2021-20225 CVE-2021-20233
# 0039-acpi-Don-t-register-the-acpi-command-when-locked-dow.patch
GRUB2_IGNORE_CVES += CVE-2020-14372
# CVE-2019-14865 is about a flaw in the grub2-set-bootflag tool, which
# doesn't exist upstream, but is added by the Redhat/Fedora
# packaging. Not applicable to Buildroot.
GRUB2_IGNORE_CVES += CVE-2019-14865
# CVE-2020-15705 is related to a flaw in the use of the
# grub_linuxefi_secure_validate(), which was added by Debian/Ubuntu
# patches. The issue doesn't affect upstream Grub, and
# grub_linuxefi_secure_validate() is not implemented in the grub2
# version available in Buildroot.
GRUB2_IGNORE_CVES += CVE-2020-15705

ifeq ($(BR2_TARGET_GRUB2_INSTALL_TOOLS),y)
GRUB2_INSTALL_TARGET = YES
else
GRUB2_INSTALL_TARGET = NO
endif
GRUB2_CPE_ID_VENDOR = gnu

GRUB2_BUILTIN_MODULES = $(call qstrip,$(BR2_TARGET_GRUB2_BUILTIN_MODULES))
GRUB2_BUILTIN_CONFIG = $(call qstrip,$(BR2_TARGET_GRUB2_BUILTIN_CONFIG))
GRUB2_BOOT_PARTITION = $(call qstrip,$(BR2_TARGET_GRUB2_BOOT_PARTITION))

ifeq ($(BR2_TARGET_GRUB2_I386_PC),y)
GRUB2_IMAGE = $(BINARIES_DIR)/grub.img
GRUB2_CFG = $(TARGET_DIR)/boot/grub/grub.cfg
GRUB2_PREFIX = ($(GRUB2_BOOT_PARTITION))/boot/grub
GRUB2_TUPLE = i386-pc
GRUB2_TARGET = i386
GRUB2_PLATFORM = pc
else ifeq ($(BR2_TARGET_GRUB2_I386_EFI),y)
GRUB2_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootia32.efi
GRUB2_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_PREFIX = /EFI/BOOT
GRUB2_TUPLE = i386-efi
GRUB2_TARGET = i386
GRUB2_PLATFORM = efi
else ifeq ($(BR2_TARGET_GRUB2_X86_64_EFI),y)
GRUB2_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootx64.efi
GRUB2_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_PREFIX = /EFI/BOOT
GRUB2_TUPLE = x86_64-efi
GRUB2_TARGET = x86_64
GRUB2_PLATFORM = efi
else ifeq ($(BR2_TARGET_GRUB2_ARM_UBOOT),y)
GRUB2_IMAGE = $(BINARIES_DIR)/boot-part/grub/grub.img
GRUB2_CFG = $(BINARIES_DIR)/boot-part/grub/grub.cfg
GRUB2_PREFIX = ($(GRUB2_BOOT_PARTITION))/boot/grub
GRUB2_TUPLE = arm-uboot
GRUB2_TARGET = arm
GRUB2_PLATFORM = uboot
else ifeq ($(BR2_TARGET_GRUB2_ARM_EFI),y)
GRUB2_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootarm.efi
GRUB2_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_PREFIX = /EFI/BOOT
GRUB2_TUPLE = arm-efi
GRUB2_TARGET = arm
GRUB2_PLATFORM = efi
else ifeq ($(BR2_TARGET_GRUB2_ARM64_EFI),y)
GRUB2_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootaa64.efi
GRUB2_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_PREFIX = /EFI/BOOT
GRUB2_TUPLE = arm64-efi
GRUB2_TARGET = aarch64
GRUB2_PLATFORM = efi
endif

# Grub2 is kind of special: it considers CC, LD and so on to be the
# tools to build the host programs and uses TARGET_CC, TARGET_CFLAGS,
# TARGET_CPPFLAGS, TARGET_LDFLAGS to build the bootloader itself.
#
# NOTE: TARGET_STRIP is overridden by !BR2_STRIP_strip, so always
# use the cross compile variant to ensure grub2 builds

HOST_GRUB2_CONF_ENV = \
	CPP="$(HOSTCC) -E"

GRUB2_CONF_ENV = \
	CPP="$(TARGET_CC) -E" \
	TARGET_CC="$(TARGET_CC)" \
	TARGET_CFLAGS="$(TARGET_CFLAGS)" \
	TARGET_CPPFLAGS="$(TARGET_CPPFLAGS) -fno-stack-protector" \
	TARGET_LDFLAGS="$(TARGET_LDFLAGS)" \
	TARGET_NM="$(TARGET_NM)" \
	TARGET_OBJCOPY="$(TARGET_OBJCOPY)" \
	TARGET_STRIP="$(TARGET_CROSS)strip"

GRUB2_CONF_OPTS = \
	--target=$(GRUB2_TARGET) \
	--with-platform=$(GRUB2_PLATFORM) \
	--prefix=/ \
	--exec-prefix=/ \
	--disable-grub-mkfont \
	--enable-efiemu=no \
	ac_cv_lib_lzma_lzma_code=no \
	--enable-device-mapper=no \
	--enable-libzfs=no \
	--disable-werror

HOST_GRUB2_CONF_OPTS = \
	--disable-grub-mkfont \
	--enable-efiemu=no \
	ac_cv_lib_lzma_lzma_code=no \
	--enable-device-mapper=no \
	--enable-libzfs=no \
	--disable-werror

ifeq ($(BR2_TARGET_GRUB2_I386_PC),y)
define GRUB2_IMAGE_INSTALL_ELTORITO
	cat $(HOST_DIR)/lib/grub/$(GRUB2_TUPLE)/cdboot.img $(GRUB2_IMAGE) > \
		$(BINARIES_DIR)/grub-eltorito.img
endef
endif

define GRUB2_INSTALL_IMAGES_CMDS
	mkdir -p $(dir $(GRUB2_IMAGE))
	$(HOST_DIR)/usr/bin/grub-mkimage \
		-d $(@D)/grub-core/ \
		-O $(GRUB2_TUPLE) \
		-o $(GRUB2_IMAGE) \
		-p "$(GRUB2_PREFIX)" \
		$(if $(GRUB2_BUILTIN_CONFIG),-c $(GRUB2_BUILTIN_CONFIG)) \
		$(GRUB2_BUILTIN_MODULES)
	mkdir -p $(dir $(GRUB2_CFG))
	$(INSTALL) -D -m 0644 boot/grub2/grub.cfg $(GRUB2_CFG)
	$(GRUB2_IMAGE_INSTALL_ELTORITO)
endef

ifeq ($(GRUB2_PLATFORM),efi)
define GRUB2_EFI_STARTUP_NSH
	echo $(notdir $(GRUB2_IMAGE)) > \
		$(BINARIES_DIR)/efi-part/startup.nsh
endef
GRUB2_POST_INSTALL_IMAGES_HOOKS += GRUB2_EFI_STARTUP_NSH
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
