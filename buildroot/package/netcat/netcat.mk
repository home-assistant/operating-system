################################################################################
#
# netcat
#
################################################################################

NETCAT_VERSION = 0.7.1
NETCAT_SITE = http://downloads.sourceforge.net/project/netcat/netcat/$(NETCAT_VERSION)
NETCAT_LICENSE = GPL-2.0+
NETCAT_LICENSE_FILES = COPYING
NETCAT_CPE_ID_VENDOR = netcat_project

$(eval $(autotools-package))
