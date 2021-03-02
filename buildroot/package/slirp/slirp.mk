################################################################################
#
# slirp
#
################################################################################

SLIRP_VERSION = 4.3.1
SLIRP_SOURCE = libslirp-$(SLIRP_VERSION).tar.xz
# Other "official" tarballs don't ship .tarball-version resulting in a build
# failure: https://gitlab.freedesktop.org/slirp/libslirp/-/issues/24
SLIRP_SITE = https://elmarco.fedorapeople.org
SLIRP_LICENSE = BSD-3-Clause
SLIRP_LICENSE_FILES = COPYRIGHT
SLIRP_CPE_ID_VENDOR = libslirp_project
SLIRP_CPE_ID_PRODUCT = libslirp
SLIRP_INSTALL_STAGING = YES
SLIRP_DEPENDENCIES = libglib2

# 0001-slirp-check-pkt_len-before-reading-protocol-header.patch
SLIRP_IGNORE_CVES += CVE-2020-29129 CVE-2020-29130

$(eval $(meson-package))
