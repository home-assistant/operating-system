################################################################################
#
# oath-toolkit
#
################################################################################

OATHTOOLKIT_VERSION = 2.6.1
OATHTOOLKIT_SOURCE = oath-toolkit-$(OATHTOOLKIT_VERSION).tar.gz
OATHTOOLKIT_SITE = http://gnu.mirrors.pair.com/savannah/savannah/oath-toolkit
OATHTOOLKIT_LICENSE = GPLv3, LGPLv2
OATHTOOLKIT_LICENSE_FILES = COPYING
OATHTOOLKIT_INSTALL_STAGING = YES
OATHTOOLKIT_CONF_OPTS += --disable-pskc --disable-xmltest

$(eval $(autotools-package))
