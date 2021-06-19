################################################################################
#
# libmspack
#
################################################################################

LIBMSPACK_VERSION_MAJOR = 0.10.1
LIBMSPACK_VERSION_MINOR = alpha
LIBMSPACK_VERSION = $(LIBMSPACK_VERSION_MAJOR)$(LIBMSPACK_VERSION_MINOR)
LIBMSPACK_SITE = https://www.cabextract.org.uk/libmspack
LIBMSPACK_LICENSE = LGPL-2.1
LIBMSPACK_LICENSE_FILES = COPYING.LIB
LIBMSPACK_CPE_ID_VENDOR = kyzer
LIBMSPACK_CPE_ID_VERSION = $(LIBMSPACK_VERSION_MAJOR)
LIBMSPACK_CPE_ID_UPDATE = $(LIBMSPACK_VERSION_MINOR)
LIBMSPACK_INSTALL_STAGING = YES

$(eval $(autotools-package))
