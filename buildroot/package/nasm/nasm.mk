################################################################################
#
# nasm
#
################################################################################

NASM_VERSION = 2.15.05
NASM_SOURCE = nasm-$(NASM_VERSION).tar.xz
NASM_SITE = https://www.nasm.us/pub/nasm/releasebuilds/$(NASM_VERSION)
NASM_LICENSE = BSD-2-Clause
NASM_LICENSE_FILES = LICENSE
NASM_CPE_ID_VENDOR = nasm
NASM_CPE_ID_PRODUCT = netwide_assembler

$(eval $(host-autotools-package))
