################################################################################
#
# libcutl
#
################################################################################

LIBCUTL_VERSION_MAJOR = 1.10
LIBCUTL_VERSION = $(LIBCUTL_VERSION_MAJOR).0
LIBCUTL_SOURCE = libcutl-$(LIBCUTL_VERSION).tar.bz2
LIBCUTL_SITE = https://www.codesynthesis.com/download/libcutl/$(LIBCUTL_VERSION_MAJOR)
LIBCUTL_INSTALL_STAGING = YES
LIBCUTL_LICENSE = MIT
LIBCUTL_LICENSE_FILES = LICENSE

$(eval $(host-autotools-package))
