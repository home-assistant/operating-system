################################################################################
#
# libseccomp
#
################################################################################

LIBSECCOMP_VERSION = 2.4.4
LIBSECCOMP_SITE = https://github.com/seccomp/libseccomp/releases/download/v$(LIBSECCOMP_VERSION)
LIBSECCOMP_LICENSE = LGPL-2.1
LIBSECCOMP_LICENSE_FILES = LICENSE
LIBSECCOMP_INSTALL_STAGING = YES

$(eval $(autotools-package))
