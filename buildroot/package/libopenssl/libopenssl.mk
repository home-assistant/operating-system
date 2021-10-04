################################################################################
#
# libopenssl
#
################################################################################

LIBOPENSSL_VERSION = 1.1.1l
LIBOPENSSL_SITE = https://www.openssl.org/source
LIBOPENSSL_SOURCE = openssl-$(LIBOPENSSL_VERSION).tar.gz
LIBOPENSSL_LICENSE = OpenSSL or SSLeay
LIBOPENSSL_LICENSE_FILES = LICENSE
LIBOPENSSL_INSTALL_STAGING = YES
LIBOPENSSL_DEPENDENCIES = zlib
HOST_LIBOPENSSL_DEPENDENCIES = host-zlib
LIBOPENSSL_TARGET_ARCH = $(call qstrip,$(BR2_PACKAGE_LIBOPENSSL_TARGET_ARCH))
LIBOPENSSL_CFLAGS = $(TARGET_CFLAGS)
LIBOPENSSL_PROVIDES = openssl
LIBOPENSSL_CPE_ID_VENDOR = $(LIBOPENSSL_PROVIDES)
LIBOPENSSL_CPE_ID_PRODUCT = $(LIBOPENSSL_PROVIDES)

ifeq ($(BR2_m68k_cf),y)
# relocation truncated to fit: R_68K_GOT16O
LIBOPENSSL_CFLAGS += -mxgot
# resolves an assembler "out of range error" with blake2 and sha512 algorithms
LIBOPENSSL_CFLAGS += -DOPENSSL_SMALL_FOOTPRINT
endif

ifeq ($(BR2_USE_MMU),)
LIBOPENSSL_CFLAGS += -DHAVE_FORK=0 -DOPENSSL_NO_MADVISE
endif

ifeq ($(BR2_PACKAGE_HAS_CRYPTODEV),y)
LIBOPENSSL_DEPENDENCIES += cryptodev
endif

# fixes the following build failures:
#
# - musl
#   ./libcrypto.so: undefined reference to `getcontext'
#   ./libcrypto.so: undefined reference to `setcontext'
#   ./libcrypto.so: undefined reference to `makecontext'
#
# - uclibc:
#   crypto/async/arch/../arch/async_posix.h:32:5: error: unknown type name 'ucontext_t'
#

ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
LIBOPENSSL_CFLAGS += -DOPENSSL_NO_ASYNC
endif
ifeq ($(BR2_TOOLCHAIN_HAS_UCONTEXT),)
LIBOPENSSL_CFLAGS += -DOPENSSL_NO_ASYNC
endif

define HOST_LIBOPENSSL_CONFIGURE_CMDS
	(cd $(@D); \
		$(HOST_CONFIGURE_OPTS) \
		./config \
		--prefix=$(HOST_DIR) \
		--openssldir=$(HOST_DIR)/etc/ssl \
		no-tests \
		no-fuzz-libfuzzer \
		no-fuzz-afl \
		shared \
		zlib-dynamic \
	)
	$(SED) "s#-O[0-9sg]#$(HOST_CFLAGS)#" $(@D)/Makefile
endef

define LIBOPENSSL_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		./Configure \
			$(LIBOPENSSL_TARGET_ARCH) \
			--prefix=/usr \
			--openssldir=/etc/ssl \
			$(if $(BR2_TOOLCHAIN_HAS_LIBATOMIC),-latomic) \
			$(if $(BR2_TOOLCHAIN_HAS_THREADS),threads,no-threads) \
			$(if $(BR2_STATIC_LIBS),no-shared,shared) \
			$(if $(BR2_PACKAGE_HAS_CRYPTODEV),enable-devcryptoeng) \
			no-rc5 \
			enable-camellia \
			enable-mdc2 \
			no-tests \
			no-fuzz-libfuzzer \
			no-fuzz-afl \
			$(if $(BR2_STATIC_LIBS),zlib,zlib-dynamic) \
			$(if $(BR2_STATIC_LIBS),no-dso) \
	)
	$(SED) "s#-march=[-a-z0-9] ##" -e "s#-mcpu=[-a-z0-9] ##g" $(@D)/Makefile
	$(SED) "s#-O[0-9sg]#$(LIBOPENSSL_CFLAGS)#" $(@D)/Makefile
	$(SED) "s# build_tests##" $(@D)/Makefile
endef

# libdl is not available in a static build, and this is not implied by no-dso
ifeq ($(BR2_STATIC_LIBS),y)
define LIBOPENSSL_FIXUP_STATIC_MAKEFILE
	$(SED) 's#-ldl##g' $(@D)/Makefile
endef
LIBOPENSSL_POST_CONFIGURE_HOOKS += LIBOPENSSL_FIXUP_STATIC_MAKEFILE
endif

define HOST_LIBOPENSSL_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBOPENSSL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBOPENSSL_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define HOST_LIBOPENSSL_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

define LIBOPENSSL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	rm -rf $(TARGET_DIR)/usr/lib/ssl
	rm -f $(TARGET_DIR)/usr/bin/c_rehash
endef

# libdl has no business in a static build
ifeq ($(BR2_STATIC_LIBS),y)
define LIBOPENSSL_FIXUP_STATIC_PKGCONFIG
	$(SED) 's#-ldl##' $(STAGING_DIR)/usr/lib/pkgconfig/libcrypto.pc
	$(SED) 's#-ldl##' $(STAGING_DIR)/usr/lib/pkgconfig/libssl.pc
	$(SED) 's#-ldl##' $(STAGING_DIR)/usr/lib/pkgconfig/openssl.pc
endef
LIBOPENSSL_POST_INSTALL_STAGING_HOOKS += LIBOPENSSL_FIXUP_STATIC_PKGCONFIG
endif

ifeq ($(BR2_PACKAGE_PERL),)
define LIBOPENSSL_REMOVE_PERL_SCRIPTS
	$(RM) -f $(TARGET_DIR)/etc/ssl/misc/{CA.pl,tsget}
endef
LIBOPENSSL_POST_INSTALL_TARGET_HOOKS += LIBOPENSSL_REMOVE_PERL_SCRIPTS
endif

ifeq ($(BR2_PACKAGE_LIBOPENSSL_BIN),)
define LIBOPENSSL_REMOVE_BIN
	$(RM) -f $(TARGET_DIR)/usr/bin/openssl
	$(RM) -f $(TARGET_DIR)/etc/ssl/misc/{CA.*,c_*}
endef
LIBOPENSSL_POST_INSTALL_TARGET_HOOKS += LIBOPENSSL_REMOVE_BIN
endif

ifneq ($(BR2_PACKAGE_LIBOPENSSL_ENGINES),y)
define LIBOPENSSL_REMOVE_LIBOPENSSL_ENGINES
	rm -rf $(TARGET_DIR)/usr/lib/engines-1.1
endef
LIBOPENSSL_POST_INSTALL_TARGET_HOOKS += LIBOPENSSL_REMOVE_LIBOPENSSL_ENGINES
endif

$(eval $(generic-package))
$(eval $(host-generic-package))
