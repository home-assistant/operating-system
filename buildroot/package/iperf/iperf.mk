################################################################################
#
# iperf
#
################################################################################

IPERF_VERSION = 2.0.13
IPERF_SITE = http://downloads.sourceforge.net/project/iperf2
IPERF_LICENSE = MIT-like
IPERF_LICENSE_FILES = COPYING
IPERF_CPE_ID_VENDOR = iperf2_project
IPERF_CPE_ID_PRODUCT = iperf2

IPERF_CONF_OPTS = \
	--disable-web100

$(eval $(autotools-package))
