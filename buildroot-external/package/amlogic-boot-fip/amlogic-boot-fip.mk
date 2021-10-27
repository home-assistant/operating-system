################################################################################
#
# amlogic-boot-fip
#
################################################################################

AMLOGIC_BOOT_FIP_VERSION = 6041db8dfd3d8f815a338d78480e9b32c6abc7d4
AMLOGIC_BOOT_FIP_SITE = https://github.com/LibreELEC/amlogic-boot-fip
AMLOGIC_BOOT_FIP_SITE_METHOD = git
AMLOGIC_BOOT_FIP_INSTALL_IMAGES = YES
AMLOGIC_BOOT_FIP_DEPENDENCIES = uboot

AMLOGIC_BOOT_FIP_LICENSE = PROPRIETARY
AMLOGIC_BOOT_FIP_REDISTRIBUTE = NO

AMLOGIC_BOOT_BINS += u-boot.bin.sd.bin


ifeq ($(BR2_PACKAGE_AMLOGIC_BOOT_FIP_JETHUB_J80),y)
define AMLOGIC_BOOT_FIP_BUILD_CMDS
    mkdir -p $(@D)/fip
    cp $(BINARIES_DIR)/u-boot.bin $(@D)/fip/bl33.bin

    $(@D)/jethub-j80/blx_fix.sh $(@D)/jethub-j80/bl30.bin \
                       $(@D)/jethub-j80/zero_tmp \
                       $(@D)/jethub-j80/bl30_zero.bin \
                       $(@D)/jethub-j80/bl301.bin \
                       $(@D)/jethub-j80/bl301_zero.bin \
                       $(@D)/jethub-j80/bl30_new.bin bl30

    python3 $(@D)/jethub-j80/acs_tool.py $(@D)/jethub-j80/bl2.bin $(@D)/jethub-j80/bl2_acs.bin $(@D)/jethub-j80/acs.bin 0

    $(@D)/jethub-j80/blx_fix.sh $(@D)/jethub-j80/bl2_acs.bin \
                       $(@D)/jethub-j80/zero_tmp \
                       $(@D)/jethub-j80/bl2_zero.bin \
                       $(@D)/jethub-j80/bl21.bin \
                       $(@D)/jethub-j80/bl21_zero.bin \
                       $(@D)/jethub-j80/bl2_new.bin bl2

    $(@D)/jethub-j80/aml_encrypt_gxl --bl3enc --input $(@D)/jethub-j80/bl30_new.bin --output $(@D)/jethub-j80/bl30_new.bin.enc
    $(@D)/jethub-j80/aml_encrypt_gxl --bl3enc --input $(@D)/jethub-j80/bl31.img --output $(@D)/jethub-j80/bl31.img.enc
    $(@D)/jethub-j80/aml_encrypt_gxl --bl3enc --input $(@D)/fip/bl33.bin --output $(@D)/jethub-j80/bl33.bin.enc
    $(@D)/jethub-j80/aml_encrypt_gxl --bl2sig --input $(@D)/jethub-j80/bl2_new.bin \
			--output $(@D)/jethub-j80/bl2.n.bin.sig

    $(@D)/jethub-j80/aml_encrypt_gxl --bootmk --output $(@D)/fip/u-boot.bin \
			--bl2 $(@D)/jethub-j80/bl2.n.bin.sig \
			--bl30 $(@D)/jethub-j80/bl30_new.bin.enc \
			--bl31 $(@D)/jethub-j80/bl31.img.enc \
			--bl33 $(@D)/jethub-j80/bl33.bin.enc
    cp -f $(@D)/fip/u-boot.bin.sd.bin $(BINARIES_DIR)/u-boot.bin.sd.bin
endef

endif

ifeq ($(BR2_PACKAGE_AMLOGIC_BOOT_FIP_JETHUB_J100),y)
define AMLOGIC_BOOT_FIP_BUILD_CMDS
#+	./blx_fix.sh bl30.bin ${TMP}/zero_tmp ${TMP}/bl30_zero.bin bl301.bin ${TMP}/bl301_zero.bin ${TMP}/bl30_new.bin bl30
#+	python3 acs_tool.py bl2.bin ${TMP}/bl2_acs.bin acs.bin 0
#+	./blx_fix.sh ${TMP}/bl2_acs.bin ${TMP}/zero_tmp ${TMP}/bl2_zero.bin bl21.bin ${TMP}/bl21_zero.bin ${TMP}/bl2_new.bin bl2
#+	./${AML_ENCRYPT} --bl3sig --input ${TMP}/bl30_new.bin --output ${TMP}/bl30_new.bin.enc  --level 3 --type bl30
#+	./${AML_ENCRYPT} --bl3sig --input bl31.img --output ${TMP}/bl31.img.enc --level 3 --type bl31
#	./${AML_ENCRYPT} --bl3sig --input ${BL33} --output ${TMP}/bl33.bin.enc --level 3 --type bl33 ${BL33_ARGS}
#	./${AML_ENCRYPT} --bl2sig --input ${TMP}/bl2_new.bin --output ${TMP}/bl2.n.bin.sig
#	./${AML_ENCRYPT} --bootmk --output ${O}/u-boot.bin --level v3 \
#	               --bl2 ${TMP}/bl2.n.bin.sig --bl30 ${TMP}/bl30_new.bin.enc \
#		       --bl31 ${TMP}/bl31.img.enc --bl33 ${TMP}/bl33.bin.enc \
#		       --level 3

    mkdir -p $(@D)/fip
    cp $(BINARIES_DIR)/u-boot.bin $(@D)/fip/bl33.bin
    $(@D)/jethub-j100/blx_fix.sh 	$(@D)/jethub-j100/bl30.bin \
			$(@D)/jethub-j100/zero_tmp \
			$(@D)/jethub-j100/bl30_zero.bin \
			$(@D)/jethub-j100/bl301.bin \
			$(@D)/jethub-j100/bl301_zero.bin \
			$(@D)/jethub-j100/bl30_new.bin bl30

	python3 $(@D)/jethub-j100/acs_tool.py $(@D)/jethub-j100/bl2.bin \
			$(@D)/jethub-j100/bl2_acs.bin \
			$(@D)/jethub-j100/acs.bin 0

	$(@D)/jethub-j100/blx_fix.sh 	$(@D)/jethub-j100/bl2_acs.bin \
			$(@D)/jethub-j100/zero_tmp \
			$(@D)/jethub-j100/bl2_zero.bin \
			$(@D)/jethub-j100/bl21.bin \
			$(@D)/jethub-j100/bl21_zero.bin \
			$(@D)/jethub-j100/bl2_new.bin bl2

	$(@D)/jethub-j100/aml_encrypt_axg        --bl3sig --input $(@D)/jethub-j100/bl30_new.bin \
                                --output $(@D)/jethub-j100/bl30_new.bin.enc \
                                --level v3 --type bl30

	$(@D)/jethub-j100/aml_encrypt_axg        --bl3sig --input $(@D)/jethub-j100/bl31.img \
                                --output $(@D)/jethub-j100/bl31.img.enc \
                                --level v3 --type bl31

	$(@D)/jethub-j100/aml_encrypt_axg        --bl3sig --input $(@D)/fip/bl33.bin --compress lz4 \
                                --output $(@D)/jethub-j100/bl33.bin.enc \
                                --level v3 --type bl33

	$(@D)/jethub-j100/aml_encrypt_axg        --bl2sig --input $(@D)/jethub-j100/bl2_new.bin \
                                --output $(@D)/jethub-j100/bl2.n.bin.sig

	$(@D)/jethub-j100/aml_encrypt_axg        --bootmk \
                                --output $(@D)/fip/u-boot.bin \
                                --bl2 $(@D)/jethub-j100/bl2.n.bin.sig \
                                --bl30 $(@D)/jethub-j100/bl30_new.bin.enc \
                                --bl31 $(@D)/jethub-j100/bl31.img.enc \
                                --bl33 $(@D)/jethub-j100/bl33.bin.enc --level v3
	cp -f $(@D)/fip/u-boot.bin.sd.bin  $(BINARIES_DIR)/u-boot.bin.sd.bin
endef
endif

define AMLOGIC_BOOT__INSTALL_IMAGES_CMDS
	$(foreach f,$(AMLOGIC_BOOT_BINS), \
			cp -dpf $(@D)/$(f) $(BINARIES_DIR)/
	)
endef

$(eval $(generic-package))
