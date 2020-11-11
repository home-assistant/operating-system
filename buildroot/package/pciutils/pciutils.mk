################################################################################
#
# pciutils
#
################################################################################

PCIUTILS_VERSION = 3.7.0
PCIUTILS_SITE = $(BR2_KERNEL_MIRROR)/software/utils/pciutils
PCIUTILS_SOURCE = pciutils-$(PCIUTILS_VERSION).tar.xz
PCIUTILS_INSTALL_STAGING = YES
PCIUTILS_LICENSE = GPL-2.0+
PCIUTILS_LICENSE_FILES = COPYING
PCIUTILS_MAKE_OPTS = \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	HOST="$(KERNEL_ARCH)-linux" \
	OPT="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	DNS=no \
	STRIP=

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
PCIUTILS_DEPENDENCIES += udev
PCIUTILS_MAKE_OPTS += HWDB=yes
else
PCIUTILS_MAKE_OPTS += HWDB=no
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
PCIUTILS_MAKE_OPTS += ZLIB=yes
PCIUTILS_DEPENDENCIES += zlib
else
PCIUTILS_MAKE_OPTS += ZLIB=no
endif

ifeq ($(BR2_PACKAGE_KMOD),y)
PCIUTILS_DEPENDENCIES += kmod
PCIUTILS_MAKE_OPTS += LIBKMOD=yes
else
PCIUTILS_MAKE_OPTS += LIBKMOD=no
endif

ifeq ($(BR2_STATIC_LIBS),y)
PCIUTILS_MAKE_OPTS += SHARED=no
else
PCIUTILS_MAKE_OPTS += SHARED=yes
endif

define PCIUTILS_CONFIGURE_CMDS
	$(SED) 's/wget --no-timestamping/wget/' $(PCIUTILS_DIR)/update-pciids.sh
endef

define PCIUTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(PCIUTILS_MAKE_OPTS) \
		PREFIX=/usr
endef

define PCIUTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) $(PCIUTILS_MAKE_OPTS) \
		PREFIX=$(TARGET_DIR)/usr SBINDIR=$(TARGET_DIR)/usr/bin \
		install install-lib install-pcilib
endef

define PCIUTILS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) $(PCIUTILS_MAKE_OPTS) \
		PREFIX=$(STAGING_DIR)/usr SBINDIR=$(STAGING_DIR)/usr/bin \
		install install-lib install-pcilib
endef

$(eval $(generic-package))
