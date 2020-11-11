################################################################################
#
# daq
#
################################################################################

DAQ_VERSION = 2.0.7
DAQ_SITE = https://www.snort.org/downloads/snort
DAQ_LICENSE = GPL-2.0
DAQ_LICENSE_FILES = COPYING
DAQ_INSTALL_STAGING = YES
DAQ_DEPENDENCIES = host-bison host-flex
# 0002-parallel-grammar.patch
# 2.0.7 needs autoreconf due to configure being older than configure.ac
DAQ_AUTORECONF = YES

# disable ipq module as libipq is deprecated
DAQ_CONF_OPTS += --disable-ipq-module

# Set --with-dnet-{includes,libraries} even if ipq and nfq modules are disabled
# otherwise daq will call 'dnet-config --cflags' and 'dnet-config --libs' which
# will result in a build failure if libdnet is installed on host
DAQ_CONF_OPTS += \
	--with-dnet-includes=$(STAGING_DIR)/usr/include \
	--with-dnet-libraries=$(STAGING_DIR)/usr/lib

ifeq ($(BR2_PACKAGE_LIBDNET)$(BR2_PACKAGE_LIBNETFILTER_QUEUE),yy)
DAQ_DEPENDENCIES += libdnet libnetfilter_queue
DAQ_CONF_OPTS += --enable-nfq-module
else
DAQ_CONF_OPTS += --disable-nfq-module
endif

ifeq ($(BR2_PACKAGE_LIBPCAP),y)
DAQ_DEPENDENCIES += libpcap
# assume these flags are available to prevent configure from running
# test programs while cross compiling
DAQ_CONF_ENV += \
	ac_cv_lib_pcap_pcap_lib_version=yes \
	daq_cv_libpcap_version_1x=yes
DAQ_CONF_OPTS += --enable-pcap-module
else
DAQ_CONF_OPTS += --disable-pcap-module
endif

$(eval $(autotools-package))
