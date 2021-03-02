################################################################################
#
# vdr
#
################################################################################

VDR_VERSION = 2.4.6
VDR_SOURCE = vdr-$(VDR_VERSION).tar.bz2
VDR_SITE = ftp://ftp.tvdr.de/vdr
VDR_LICENSE = GPL-2.0+
VDR_LICENSE_FILES = COPYING
VDR_CPE_ID_VENDOR = tvdr
VDR_INSTALL_STAGING = YES
VDR_DEPENDENCIES = \
	host-pkgconf \
	freetype \
	fontconfig \
	jpeg \
	libcap \
	$(TARGET_NLS_DEPENDENCIES)

VDR_MAKE_FLAGS = \
	NO_KBD=yes \
	PKG_CONFIG=$(PKG_CONFIG_HOST_BINARY) \
	PLUGINLIBDIR=/usr/lib/vdr \
	PREFIX=/usr \
	VIDEODIR=/var/lib/vdr
VDR_LDFLAGS = $(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
VDR_DEPENDENCIES += libfribidi
VDR_MAKE_FLAGS += BIDI=1
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
VDR_DEPENDENCIES += libiconv
VDR_LDFLAGS += -liconv
endif

VDR_MAKE_ENV = \
	LDFLAGS="$(VDR_LDFLAGS)" \
	$(VDR_MAKE_FLAGS)

define VDR_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) $(VDR_MAKE_ENV) \
		vdr vdr.pc include-dir
endef

define VDR_INSTALL_STAGING_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) $(VDR_MAKE_ENV) \
		DESTDIR=$(STAGING_DIR) \
		install-dirs install-bin install-conf install-includes \
		install-pc
endef

define VDR_INSTALL_TARGET_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) $(VDR_MAKE_ENV) \
		DESTDIR=$(TARGET_DIR) \
		install-dirs install-bin install-conf
endef

$(eval $(generic-package))
