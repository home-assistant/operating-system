################################################################################
#
# libnetfilter_conntrack
#
################################################################################

LIBNETFILTER_CONNTRACK_VERSION = 1.0.8
LIBNETFILTER_CONNTRACK_SOURCE = libnetfilter_conntrack-$(LIBNETFILTER_CONNTRACK_VERSION).tar.bz2
LIBNETFILTER_CONNTRACK_SITE = http://www.netfilter.org/projects/libnetfilter_conntrack/files
LIBNETFILTER_CONNTRACK_INSTALL_STAGING = YES
LIBNETFILTER_CONNTRACK_DEPENDENCIES = host-pkgconf libnfnetlink libmnl
LIBNETFILTER_CONNTRACK_LICENSE = GPL-2.0+
LIBNETFILTER_CONNTRACK_LICENSE_FILES = COPYING
LIBNETFILTER_CONNTRACK_CPE_ID_VENDOR = netfilter

$(eval $(autotools-package))
