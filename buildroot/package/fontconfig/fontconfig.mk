################################################################################
#
# fontconfig
#
################################################################################

FONTCONFIG_VERSION = 2.13.1
FONTCONFIG_SITE = http://fontconfig.org/release
FONTCONFIG_SOURCE = fontconfig-$(FONTCONFIG_VERSION).tar.bz2
# 0002-add-pthread-as-a-dependency-of-a-static-lib.patch
FONTCONFIG_AUTORECONF = YES
FONTCONFIG_INSTALL_STAGING = YES
FONTCONFIG_DEPENDENCIES = freetype expat host-pkgconf host-gperf \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBS),util-linux-libs,util-linux) \
	$(TARGET_NLS_DEPENDENCIES)
HOST_FONTCONFIG_DEPENDENCIES = \
	host-freetype host-expat host-pkgconf host-gperf host-util-linux \
	host-gettext
FONTCONFIG_LICENSE = fontconfig license
FONTCONFIG_LICENSE_FILES = COPYING
FONTCONFIG_CPE_ID_VENDOR = fontconfig_project

FONTCONFIG_CONF_OPTS = \
	--with-arch=$(GNU_TARGET_NAME) \
	--with-cache-dir=/var/cache/fontconfig \
	--disable-docs

HOST_FONTCONFIG_CONF_OPTS = \
	--disable-static

$(eval $(autotools-package))
$(eval $(host-autotools-package))
