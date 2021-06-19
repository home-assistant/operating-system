################################################################################
#
# expat
#
################################################################################

EXPAT_VERSION = 2.4.1
EXPAT_SITE = http://downloads.sourceforge.net/project/expat/expat/$(EXPAT_VERSION)
EXPAT_SOURCE = expat-$(EXPAT_VERSION).tar.xz
EXPAT_INSTALL_STAGING = YES
EXPAT_DEPENDENCIES = host-pkgconf
HOST_EXPAT_DEPENDENCIES = host-pkgconf
EXPAT_LICENSE = MIT
EXPAT_LICENSE_FILES = COPYING
EXPAT_CPE_ID_VENDOR = libexpat_project
EXPAT_CPE_ID_PRODUCT = libexpat

EXPAT_CONF_OPTS = --without-docbook
HOST_EXPAT_CONF_OPTS = --without-docbook

$(eval $(autotools-package))
$(eval $(host-autotools-package))
