################################################################################
#
# jethome uboot loader
#
################################################################################

JETHOME_BOOT_VERSION = HEAD
JETHOME_BOOT_SITE = https://github.com/jethome-ru/jethub-prebuilt-u-boot.git
JETHOME_BOOT_SITE_METHOD = git
JETHOME_BOOT_INSTALL_IMAGES = YES
JETHOME_BOOT_DEPENDENCIES = uboot
JETHOME_BOOT_BINS = u-boot.bin u-boot.bin.usb.tpl u-boot.bin.usb.bl2


ifeq ($(BR2_PACKAGE_JETHOME_BOOT_JETHUB_D1),y)
JETHOME_BOOT_DEVICE = jethub-j100

else ifeq ($(BR2_PACKAGE_JETHOME_BOOT_JETHUB_H1),y)
JETHOME_BOOT_DEVICE = jethub-j80

endif

define JETHOME_BOOT_INSTALL_IMAGES_CMDS
	$(foreach f,$(JETHOME_BOOT_BINS), \
			cp -dpf $(@D)/hassos/$(JETHOME_BOOT_DEVICE)/$(f) $(BINARIES_DIR)/
	)
endef

$(eval $(generic-package))
