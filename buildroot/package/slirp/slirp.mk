################################################################################
#
# slirp
#
################################################################################

SLIRP_VERSION = 4.6.1
SLIRP_SOURCE = libslirp-$(SLIRP_VERSION).tar.xz
SLIRP_SITE = https://gitlab.freedesktop.org/slirp/libslirp/uploads/83b199ea6fcdfc0c243dfde8546ee4c9
SLIRP_LICENSE = BSD-3-Clause
SLIRP_LICENSE_FILES = COPYRIGHT
SLIRP_CPE_ID_VENDOR = libslirp_project
SLIRP_CPE_ID_PRODUCT = libslirp
SLIRP_INSTALL_STAGING = YES
SLIRP_DEPENDENCIES = libglib2

$(eval $(meson-package))
