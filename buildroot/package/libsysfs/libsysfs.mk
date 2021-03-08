################################################################################
#
# libsysfs
#
################################################################################

LIBSYSFS_VERSION = 2.1.0
LIBSYSFS_SITE = http://downloads.sourceforge.net/project/linux-diag/sysfsutils/$(LIBSYSFS_VERSION)
LIBSYSFS_SOURCE = sysfsutils-$(LIBSYSFS_VERSION).tar.gz
LIBSYSFS_INSTALL_STAGING = YES
LIBSYSFS_LICENSE = GPL-2.0 (utilities), LGPL-2.1+ (library)
LIBSYSFS_LICENSE_FILES = cmd/GPL lib/LGPL
LIBSYSFS_CPE_ID_VENDOR = sysfsutils_project
LIBSYSFS_CPE_ID_PRODUCT = sysfsutils

$(eval $(autotools-package))
