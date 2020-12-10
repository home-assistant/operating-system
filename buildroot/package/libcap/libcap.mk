################################################################################
#
# libcap
#
################################################################################

LIBCAP_VERSION = 2.45
LIBCAP_SITE = https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2
LIBCAP_SOURCE = libcap-$(LIBCAP_VERSION).tar.xz
LIBCAP_LICENSE = GPL-2.0 or BSD-3-Clause
LIBCAP_LICENSE_FILES = License

LIBCAP_DEPENDENCIES = host-libcap host-gperf
LIBCAP_INSTALL_STAGING = YES

HOST_LIBCAP_DEPENDENCIES = host-gperf

LIBCAP_MAKE_FLAGS = \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	BUILD_CC="$(HOSTCC)" \
	BUILD_CFLAGS="$(HOST_CFLAGS)" \
	lib=lib \
	prefix=/usr \
	SHARED=$(if $(BR2_STATIC_LIBS),,yes) \
	PTHREADS=$(if $(BR2_TOOLCHAIN_HAS_THREADS),yes,)

LIBCAP_MAKE_DIRS = libcap

ifeq ($(BR2_PACKAGE_LIBCAP_TOOLS),y)
LIBCAP_MAKE_DIRS += progs
endif

define LIBCAP_BUILD_CMDS
	$(foreach d,$(LIBCAP_MAKE_DIRS), \
		$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/$(d) \
			$(LIBCAP_MAKE_FLAGS) all
	)
endef

define LIBCAP_INSTALL_STAGING_CMDS
	$(foreach d,$(LIBCAP_MAKE_DIRS), \
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$(d) $(LIBCAP_MAKE_FLAGS) \
			DESTDIR=$(STAGING_DIR) install
	)
endef

define LIBCAP_INSTALL_TARGET_CMDS
	$(foreach d,$(LIBCAP_MAKE_DIRS), \
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$(d) $(LIBCAP_MAKE_FLAGS) \
			DESTDIR=$(TARGET_DIR) install
	)
endef

HOST_LIBCAP_MAKE_FLAGS = \
	DYNAMIC=yes \
	GOLANG=no \
	lib=lib \
	prefix=$(HOST_DIR) \
	RAISE_SETFCAP=no

define HOST_LIBCAP_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(HOST_LIBCAP_MAKE_FLAGS)
endef

define HOST_LIBCAP_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_LIBCAP_MAKE_FLAGS) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
