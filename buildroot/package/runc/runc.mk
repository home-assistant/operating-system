################################################################################
#
# runc
#
################################################################################

RUNC_VERSION = 1.0.2
RUNC_SITE = $(call github,opencontainers,runc,v$(RUNC_VERSION))
RUNC_LICENSE = Apache-2.0
RUNC_LICENSE_FILES = LICENSE
RUNC_CPE_ID_VENDOR = linuxfoundation

RUNC_LDFLAGS = -X main.version=$(RUNC_VERSION)
RUNC_TAGS = cgo static_build

ifeq ($(BR2_PACKAGE_LIBAPPARMOR),y)
RUNC_DEPENDENCIES += libapparmor
RUNC_TAGS += apparmor
endif

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
RUNC_TAGS += seccomp
RUNC_DEPENDENCIES += libseccomp host-pkgconf
endif

$(eval $(golang-package))
