################################################################################
#
# hardkernel secure boot loader
#
################################################################################

HARDKERNEL_BOOT_SOURCE = $(HARDKERNEL_BOOT_VERSION).tar.gz
HARDKERNEL_BOOT_SITE = https://github.com/hardkernel/u-boot/archive
HARDKERNEL_BOOT_LICENSE = GPL-2.0+
HARDKERNEL_BOOT_LICENSE_FILES = Licenses/gpl-2.0.txt
HARDKERNEL_BOOT_INSTALL_IMAGES = YES
HARDKERNEL_BOOT_DEPENDENCIES = uboot

ifeq ($(BR2_PACKAGE_HARDKERNEL_BOOT_ODROID_C2),y)
HARDKERNEL_BOOT_VERSION = 205c7b3259559283161703a1a200b787c2c445a5

HARDKERNEL_BOOT_BINS += sd_fuse/bl1.bin.hardkernel
HARDKERNEL_BOOT_BINS += u-boot.gxbb

define HARDKERNEL_BOOT_BUILD_CMDS
	$(@D)/fip/fip_create --bl30  $(@D)/fip/gxb/bl30.bin \
		--bl301 $(@D)/fip/gxb/bl301.bin \
		--bl31  $(@D)/fip/gxb/bl31.bin \
		--bl33  $(BINARIES_DIR)/u-boot.bin \
		$(@D)/fip.bin

	cat $(@D)/fip/gxb/bl2.package $(@D)/fip.bin > $(@D)/boot_new.bin
	$(@D)/fip/gxb/aml_encrypt_gxb --bootsig \
		--input $(@D)/boot_new.bin \
		--output $(@D)/u-boot.img

	dd if=$(@D)/u-boot.img of=$(@D)/u-boot.gxbb bs=512 skip=96
endef

else ifeq ($(BR2_PACKAGE_HARDKERNEL_BOOT_ODROID_C4),y)
# travis/odroidc4-153 20201014
HARDKERNEL_BOOT_VERSION = 2a4e31e3fde9bced8a150d338aa397a0362df191

HARDKERNEL_BOOT_BINS += u-boot.sm1
define HARDKERNEL_BOOT_BUILD_CMDS
	curl -L -o $(@D)/fip/blx_fix.sh https://raw.githubusercontent.com/home-assistant/operating-system-blobs/75fa51f44221da614a717673a27bec4fa01ccd6c/hardkernel/blx_fix_g12a.sh
	curl -L -o $(@D)/fip/acs.bin https://raw.githubusercontent.com/home-assistant/operating-system-blobs/75fa51f44221da614a717673a27bec4fa01ccd6c/hardkernel/odroid-c4/acs.bin
	curl -L -o $(@D)/fip/bl301.bin https://raw.githubusercontent.com/home-assistant/operating-system-blobs/75fa51f44221da614a717673a27bec4fa01ccd6c/hardkernel/odroid-c4/bl301.bin

	bash $(@D)/fip/blx_fix.sh \
		$(@D)/fip/g12a/bl30.bin $(@D)/fip/zero_tmp $(@D)/fip/bl30_zero.bin \
		$(@D)/fip/bl301.bin $(@D)/fip/bl301_zero.bin $(@D)/fip/bl30_new.bin \
		bl30

	bash $(@D)/fip/blx_fix.sh \
		$(@D)/fip/g12a/bl2.bin $(@D)/fip/zero_tmp $(@D)/fip/bl2_zero.bin \
		$(@D)/fip/acs.bin $(@D)/fip/bl21_zero.bin $(@D)/fip/bl2_new.bin \
		bl2

	$(@D)/fip/g12a/aml_encrypt_g12a --bl30sig --input $(@D)/fip/bl30_new.bin \
		--output $(@D)/fip/bl30_new.bin.g12a.enc \
		--level v3
	$(@D)/fip/g12a/aml_encrypt_g12a --bl3sig --input $(@D)/fip/bl30_new.bin.g12a.enc \
		--output $(@D)/fip/bl30_new.bin.enc \
		--level v3 --type bl30
	$(@D)/fip/g12a/aml_encrypt_g12a --bl3sig --input $(@D)/fip/g12a/bl31.img \
		--output $(@D)/fip/bl31.img.enc \
		--level v3 --type bl31
	$(@D)/fip/g12a/aml_encrypt_g12a --bl3sig --input $(BINARIES_DIR)/u-boot.bin \
		--output $(@D)/fip/bl33.bin.enc \
		--level v3 --type bl33
	$(@D)/fip/g12a/aml_encrypt_g12a --bl2sig --input $(@D)/fip/bl2_new.bin \
		--output $(@D)/fip/bl2.n.bin.sig
	$(@D)/fip/g12a/aml_encrypt_g12a --bootmk \
		--output $(@D)/fip/u-boot.bin \
		--bl2 $(@D)/fip/bl2.n.bin.sig \
		--bl30 $(@D)/fip/bl30_new.bin.enc \
		--bl31 $(@D)/fip/bl31.img.enc \
		--bl33 $(@D)/fip/bl33.bin.enc \
		--ddrfw1 $(@D)/fip/g12a/ddr4_1d.fw \
		--ddrfw2 $(@D)/fip/g12a/ddr4_2d.fw \
		--ddrfw3 $(@D)fip/g12a/ddr3_1d.fw \
		--ddrfw4 $(@D)/fip/g12a/piei.fw \
		--ddrfw5 $(@D)/fip/g12a/lpddr4_1d.fw \
		--ddrfw6 $(@D)/fip/g12a/lpddr4_2d.fw \
		--ddrfw7 $(@D)/fip/g12a/diag_lpddr4.fw \
		--ddrfw8 $(@D)/fip/g12a/aml_ddr.fw \
		--ddrfw9 $(@D)/fip/g12a/lpddr3_1d.fw \
		--level v3

	cp $(@D)/fip/u-boot.bin $(@D)/u-boot.sm1
endef

else ifeq ($(BR2_PACKAGE_HARDKERNEL_BOOT_ODROID_XU4),y)
HARDKERNEL_BOOT_VERSION = 88af53fbcef8386cb4d5f04c19f4b2bcb69e90ca

HARDKERNEL_BOOT_BINS += sd_fuse/bl1.bin.hardkernel
HARDKERNEL_BOOT_BINS += sd_fuse/bl2.bin.hardkernel.720k_uboot
HARDKERNEL_BOOT_BINS += sd_fuse/tzsw.bin.hardkernel

define HARDKERNEL_BOOT_BUILD_CMDS
endef

else ifeq ($(BR2_PACKAGE_HARDKERNEL_BOOT_ODROID_N2),y)
HARDKERNEL_BOOT_VERSION = ca5bdd0f1c291d1ec135cd134e01aa2619203d4c

HARDKERNEL_BOOT_BINS += u-boot.g12b
define HARDKERNEL_BOOT_BUILD_CMDS
	curl -L -o $(@D)/fip/blx_fix.sh https://raw.githubusercontent.com/home-assistant/operating-system-blobs/f17a8e81e0b7e1bd2475441465cc737c0891edfa/hardkernel/blx_fix_g12a.sh
	curl -L -o $(@D)/fip/acs.bin https://raw.githubusercontent.com/home-assistant/operating-system-blobs/f17a8e81e0b7e1bd2475441465cc737c0891edfa/hardkernel/odroid-n2/acs.bin
	curl -L -o $(@D)/fip/bl301.bin https://raw.githubusercontent.com/home-assistant/operating-system-blobs/f17a8e81e0b7e1bd2475441465cc737c0891edfa/hardkernel/odroid-n2/bl301.bin

	bash $(@D)/fip/blx_fix.sh \
		$(@D)/fip/g12b/bl30.bin $(@D)/fip/zero_tmp $(@D)/fip/bl30_zero.bin \
		$(@D)/fip/bl301.bin $(@D)/fip/bl301_zero.bin $(@D)/fip/bl30_new.bin \
		bl30

	bash $(@D)/fip/blx_fix.sh \
		$(@D)/fip/g12b/bl2.bin $(@D)/fip/zero_tmp $(@D)/fip/bl2_zero.bin \
		$(@D)/fip/acs.bin $(@D)/fip/bl21_zero.bin $(@D)/fip/bl2_new.bin \
		bl2

	$(@D)/fip/g12b/aml_encrypt_g12b --bl30sig --input $(@D)/fip/bl30_new.bin \
		--output $(@D)/fip/bl30_new.bin.g12.enc \
		--level v3
	$(@D)/fip/g12b/aml_encrypt_g12b --bl3sig --input $(@D)/fip/bl30_new.bin.g12.enc \
		--output $(@D)/fip/bl30_new.bin.enc \
		--level v3 --type bl30
	$(@D)/fip/g12b/aml_encrypt_g12b --bl3sig --input $(@D)/fip/g12b/bl31.img \
		--output $(@D)/fip/bl31.img.enc \
		--level v3 --type bl31
	$(@D)/fip/g12b/aml_encrypt_g12b --bl3sig --input $(BINARIES_DIR)/u-boot.bin \
		--output $(@D)/fip/bl33.bin.enc \
		--level v3 --type bl33 --compress lz4
	$(@D)/fip/g12b/aml_encrypt_g12b --bl2sig --input $(@D)/fip/bl2_new.bin \
		--output $(@D)/fip/bl2.n.bin.sig
	$(@D)/fip/g12b/aml_encrypt_g12b --bootmk \
		--output $(@D)/fip/u-boot.bin \
		--bl2 $(@D)/fip/bl2.n.bin.sig \
		--bl30 $(@D)/fip/bl30_new.bin.enc \
		--bl31 $(@D)/fip/bl31.img.enc \
		--bl33 $(@D)/fip/bl33.bin.enc \
		--ddrfw1 $(@D)/fip/g12b/ddr4_1d.fw \
		--ddrfw2 $(@D)/fip/g12b/ddr4_2d.fw \
		--ddrfw3 $(@D)fip/g12b/ddr3_1d.fw \
		--ddrfw4 $(@D)/fip/g12b/piei.fw \
		--ddrfw5 $(@D)/fip/g12b/lpddr4_1d.fw \
		--ddrfw6 $(@D)/fip/g12b/lpddr4_2d.fw \
		--ddrfw7 $(@D)/fip/g12b/diag_lpddr4.fw \
		--ddrfw8 $(@D)/fip/g12b/aml_ddr.fw \
		--level v3

	cp $(@D)/fip/u-boot.bin $(@D)/u-boot.g12b
endef
endif

define HARDKERNEL_BOOT_INSTALL_IMAGES_CMDS
	$(foreach f,$(HARDKERNEL_BOOT_BINS), \
			cp -dpf $(@D)/$(f) $(BINARIES_DIR)/
	)
endef

$(eval $(generic-package))
