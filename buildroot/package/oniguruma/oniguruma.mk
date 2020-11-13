################################################################################
#
# oniguruma
#
################################################################################

ONIGURUMA_VERSION = 6.9.5
ONIGURUMA_SITE = \
	https://github.com/kkos/oniguruma/releases/download/v$(ONIGURUMA_VERSION)
ONIGURUMA_SOURCE = onig-$(ONIGURUMA_VERSION).tar.gz
ONIGURUMA_LICENSE = BSD-2-Clause
ONIGURUMA_LICENSE_FILES = COPYING
ONIGURUMA_INSTALL_STAGING = YES

# 0001-207-Out-of-bounds-write.patch
ONIGURUMA_IGNORE_CVES += CVE-2020-26159

$(eval $(autotools-package))
