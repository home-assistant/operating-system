################################################################################
#
# zstd
#
################################################################################

ZSTD_VERSION = 1.4.9
ZSTD_SITE = https://github.com/facebook/zstd/releases/download/v$(ZSTD_VERSION)
ZSTD_INSTALL_STAGING = YES
ZSTD_LICENSE = BSD-3-Clause or GPL-2.0
ZSTD_LICENSE_FILES = LICENSE COPYING
ZSTD_CPE_ID_VENDOR = facebook
ZSTD_CPE_ID_PRODUCT = zstandard

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
ZSTD_OPTS += HAVE_THREAD=1
else
ZSTD_OPTS += HAVE_THREAD=0
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
ZSTD_DEPENDENCIES += zlib
ZSTD_OPTS += HAVE_ZLIB=1
else
ZSTD_OPTS += HAVE_ZLIB=0
endif

ifeq ($(BR2_PACKAGE_XZ),y)
ZSTD_DEPENDENCIES += xz
ZSTD_OPTS += HAVE_LZMA=1
else
ZSTD_OPTS += HAVE_LZMA=0
endif

ifeq ($(BR2_PACKAGE_LZ4),y)
ZSTD_DEPENDENCIES += lz4
ZSTD_OPTS += HAVE_LZ4=1
else
ZSTD_OPTS += HAVE_LZ4=0
endif

ifeq ($(BR2_STATIC_LIBS),y)
ZSTD_BUILD_LIBS = libzstd.a
ZSTD_INSTALL_LIBS = install-static
else ifeq ($(BR2_SHARED_LIBS),y)
ZSTD_BUILD_LIBS = libzstd
ZSTD_INSTALL_LIBS = install-shared
else
ZSTD_BUILD_LIBS = libzstd.a libzstd
ZSTD_INSTALL_LIBS = install-static install-shared
endif

# The HAVE_THREAD flag is read by the 'programs' makefile but not by  the 'lib'
# one. Building a multi-threaded binary with a library (which defaults to
# single-threaded) gives a runtime error when compressing files.
# The 'lib' makefile provides specific '%-mt' targets for this purpose.
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
ZSTD_BUILD_LIBS := $(addsuffix -mt,$(ZSTD_BUILD_LIBS))
endif

define ZSTD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(ZSTD_OPTS) \
		-C $(@D)/lib $(ZSTD_BUILD_LIBS)
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(ZSTD_OPTS) \
		-C $(@D) zstd
endef

define ZSTD_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(ZSTD_OPTS) \
		DESTDIR=$(STAGING_DIR) PREFIX=/usr -C $(@D)/lib \
		install-pc install-includes $(ZSTD_INSTALL_LIBS)
endef

define ZSTD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(ZSTD_OPTS) \
		DESTDIR=$(TARGET_DIR) PREFIX=/usr -C $(@D)/programs install
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(ZSTD_OPTS) \
		DESTDIR=$(TARGET_DIR) PREFIX=/usr -C $(@D)/lib $(ZSTD_INSTALL_LIBS)
endef

# note: only limited 'HAVE_...' options for host library build only
HOST_ZSTD_OPTS = HAVE_THREAD=1

define HOST_ZSTD_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) $(HOST_ZSTD_OPTS) \
		-C $(@D)/lib libzstd.a-mt libzstd-mt
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) $(HOST_ZSTD_OPTS) \
		-C $(@D) zstd
endef

define HOST_ZSTD_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) $(HOST_ZSTD_OPTS) \
		DESTDIR=$(HOST_DIR) PREFIX=/usr -C $(@D)/lib install
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) $(HOST_ZSTD_OPTS) \
		DESTDIR=$(HOST_DIR) PREFIX=/usr -C $(@D)/programs install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
