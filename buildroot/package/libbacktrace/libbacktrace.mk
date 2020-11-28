################################################################################
#
# libbacktrace
#
################################################################################

LIBBACKTRACE_VERSION = 9b7f216e867916594d81e8b6118f092ac3fcf704
LIBBACKTRACE_SITE = $(call github,ianlancetaylor,libbacktrace,$(LIBBACKTRACE_VERSION))
LIBBACKTRACE_LICENSE = BSD-3C-like
LIBBACKTRACE_LICENSE_FILES = LICENSE
LIBBACKTRACE_INSTALL_STAGING = YES

$(eval $(autotools-package))
