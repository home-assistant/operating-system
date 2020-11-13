################################################################################
#
# asn1c
#
################################################################################

ASN1C_VERSION = 0.9.28
ASN1C_SITE = https://github.com/vlm/asn1c/releases/download/v$(ASN1C_VERSION)
ASN1C_LICENSE = BSD-2-Clause
ASN1C_LICENSE_FILES = LICENSE

$(eval $(host-autotools-package))
