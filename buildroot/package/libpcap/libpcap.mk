################################################################################
#
# libpcap
#
################################################################################

LIBPCAP_VERSION = 1.10.1
LIBPCAP_SITE = https://www.tcpdump.org/release
LIBPCAP_LICENSE = BSD-3-Clause
LIBPCAP_LICENSE_FILES = LICENSE
LIBPCAP_CPE_ID_VENDOR = tcpdump
LIBPCAP_INSTALL_STAGING = YES
LIBPCAP_DEPENDENCIES = host-flex host-bison host-pkgconf

# ac_cv_prog_cc_c99 is required for BR2_USE_WCHAR=n because the C99 test
# provided by autoconf relies on wchar_t.
LIBPCAP_CONF_ENV = \
	ac_cv_header_linux_wireless_h=yes \
	ac_cv_prog_cc_c99=-std=gnu99 \
	CFLAGS="$(LIBPCAP_CFLAGS)"
LIBPCAP_CFLAGS = $(TARGET_CFLAGS)
LIBPCAP_CONF_OPTS = --disable-yydebug --with-pcap=linux --without-dag \
	--without-dpdk
# Disable dbus to break recursive dependencies
LIBPCAP_CONF_OPTS += --disable-dbus
LIBPCAP_CONFIG_SCRIPTS = pcap-config

# Omit -rpath from pcap-config output
define LIBPCAP_CONFIG_REMOVE_RPATH
	$(SED) 's/^V_RPATH_OPT=.*/V_RPATH_OPT=""/g' $(@D)/pcap-config
endef
LIBPCAP_POST_BUILD_HOOKS = LIBPCAP_CONFIG_REMOVE_RPATH

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_HEADERS),y)
LIBPCAP_DEPENDENCIES += bluez5_utils-headers
else
LIBPCAP_CONF_OPTS += --disable-bluetooth
endif

ifeq ($(BR2_PACKAGE_LIBNL),y)
LIBPCAP_DEPENDENCIES += libnl
LIBPCAP_CONF_OPTS += --with-libnl
else
LIBPCAP_CONF_OPTS += --without-libnl
endif

# microblaze/sparc/sparc64 need -fPIC instead of -fpic
ifeq ($(BR2_microblaze)$(BR2_sparc)$(BR2_sparc64),y)
LIBPCAP_CFLAGS += -fPIC
endif

$(eval $(autotools-package))
