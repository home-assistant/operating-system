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

HARDKERNEL_BOOT_BINS += sd_fuse/bl1.bin.hardkernel \
                       u-boot.gxbb
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

else ifeq ($(BR2_PACKAGE_HARDKERNEL_BOOT_ODROID_XU4),y)
HARDKERNEL_BOOT_VERSION = 88af53fbcef8386cb4d5f04c19f4b2bcb69e90ca

HARDKERNEL_BOOT_BINS += sd_fuse/bl1.bin.hardkernel \
                        sd_fuse/bl2.bin.hardkernel.720k_uboot \
						sd_fuse/tzsw.bin.hardkernel
define HARDKERNEL_BOOT_BUILD_CMDS
endef
endif

define HARDKERNEL_BOOT_INSTALL_IMAGES_CMDS
	$(foreach f,$(HARDKERNEL_BOOT_BINS), \
			cp -dpf $(@D)/$(f) $(BINARIES_DIR)/
	)
endef

$(eval $(generic-package))
