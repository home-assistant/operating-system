################################################################################
#
# hardkernel secure boot loader
#
################################################################################

HARDKERNEL_SBL_VERSION = 205c7b3259559283161703a1a200b787c2c445a5
HARDKERNEL_SBL_SOURCE = $(HARDKERNEL_SBL_VERSION).tar.gz
HARDKERNEL_SBL_SITE = https://github.com/hardkernel/u-boot/archive
HARDKERNEL_SBL_LICENSE = GPL-2.0+
HARDKERNEL_SBL_LICENSE_FILES = Licenses/gpl-2.0.txt
HARDKERNEL_SBL_INSTALL_IMAGES = YES
HARDKERNEL_SBL_DEPENDENCIES = uboot


ifeq ($(BR2_PACKAGE_HARDKERNEL_SBL_ODROID_C2),y)
HARDKERNEL_SBL_BINS += sd_fuse/bl1.bin.hardkernel \
                       u-boot.gxbb
define HARDKERNEL_SBL_BUILD_CMDS
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
endif

define HARDKERNEL_SBL_INSTALL_IMAGES_CMDS
	$(foreach f,$(HARDKERNEL_SBL_BINS), \
			cp -dpf $(@D)/$(f) $(BINARIES_DIR)/
	)
endef

$(eval $(generic-package))
