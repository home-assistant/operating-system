################################################################################
#
# fbtft
#
################################################################################

FBTFT_VERSION = 274035404701245e7491c0c6471c5b72ade4d491
FBTFT_SITE = $(call github,notro,fbtft,$(FBTFT_VERSION))
FBTFT_LICENSE = GPL-2.0
FBTFT_LICENSE_FILES = fbtft-core.c

$(eval $(generic-package))
