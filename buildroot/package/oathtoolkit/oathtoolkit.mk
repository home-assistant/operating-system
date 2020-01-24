################################################################################
#
# jq
#
################################################################################

OATHTOOLKIT_VERSION = 2.6.1
OATHTOOLKIT_SOURCE = oath-toolkit-$(OATHTOOLKIT_VERSION).tar.gz
OATHTOOLKIT_SITE = http://gnu.mirrors.pair.com/savannah/savannah/oath-toolkit
OATHTOOLKIT_LICENSE = GPLv3, LGPLv2
OATHTOOLKIT_LICENSE_FILES = COPYING
OATHTOOLKIT_INSTALL_STAGING = YES
#OATHTOOLKIT_INSTALL_TARGET = YES 
OATHTOOLKIT_DEPENDENCIES = host-bison libtool 
OATHTOOLKIT_CONF_OPTS += --disable-pskc --disable-xmltest
HOST_OATHTOOLKIT_CONF_OPTS += --disable-pskc --disable-xmltest
# uses c99 specific features
# _GNU_SOURCE added to fix gcc6+ host compilation
# (https://github.com/stedolan/jq/issues/1598)
#OATHTOOL_CONF_ENV += CFLAGS="$(TARGET_CFLAGS)"
#HOST_OATHTOOL_CONF_ENV += CFLAGS="$(HOST_CFLAGS)"

$(eval $(autotools-package))
$(eval $(host-autotools-package))
