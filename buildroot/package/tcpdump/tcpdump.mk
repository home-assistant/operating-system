################################################################################
#
# tcpdump
#
################################################################################

TCPDUMP_VERSION = 4.99.0
TCPDUMP_SITE = https://www.tcpdump.org/release
TCPDUMP_LICENSE = BSD-3-Clause
TCPDUMP_LICENSE_FILES = LICENSE
TCPDUMP_CPE_ID_VENDOR = tcpdump
TCPDUMP_CONF_ENV = \
	ac_cv_linux_vers=2 \
	td_cv_buggygetaddrinfo=no \
	PCAP_CONFIG=$(STAGING_DIR)/usr/bin/pcap-config
TCPDUMP_CONF_OPTS = \
	--without-crypto \
	--disable-local-libpcap \
	$(if $(BR2_PACKAGE_TCPDUMP_SMB),--enable-smb,--disable-smb)
TCPDUMP_DEPENDENCIES = libpcap host-pkgconf
TCPDUMP_SELINUX_MODULES = netutils

# make install installs an unneeded extra copy of the tcpdump binary
define TCPDUMP_REMOVE_DUPLICATED_BINARY
	rm -f $(TARGET_DIR)/usr/bin/tcpdump.$(TCPDUMP_VERSION)
endef

TCPDUMP_POST_INSTALL_TARGET_HOOKS += TCPDUMP_REMOVE_DUPLICATED_BINARY

$(eval $(autotools-package))
