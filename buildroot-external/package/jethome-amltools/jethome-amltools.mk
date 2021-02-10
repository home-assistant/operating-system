################################################################################
#
# jethome amlogic tools
#
################################################################################

JETHOME_AMLTOOLS_VERSION = cab89fb399c66854d29c629cd592538284317434
JETHOME_AMLTOOLS_SITE = $(call github,jethome-ru,jethub-aml-tools,$(JETHOME_AMLTOOLS_VERSION))
JETHOME_AMLTOOLS_LICENSE = Unknown
JETHOME_AMLTOOLS_INSTALL_IMAGES = YES
JETHOME_AMLTOOLS_DEPENDENCIES = uboot
JETHOME_AMLTOOLS_BINS = aml_image_v2_packer_new dtbTool 

define JETHOME_AMLTOOLS_INSTALL_IMAGES_CMDS
	$(foreach f,$(JETHOME_AMLTOOLS_BINS), \
			cp -dpf $(@D)/$(f) $(BINARIES_DIR)/
	)
endef

$(eval $(generic-package))
