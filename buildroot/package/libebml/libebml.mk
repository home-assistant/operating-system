################################################################################
#
# libebml
#
################################################################################

LIBEBML_VERSION = 1.4.2
LIBEBML_SOURCE = libebml-$(LIBEBML_VERSION).tar.xz
LIBEBML_SITE = http://dl.matroska.org/downloads/libebml
LIBEBML_INSTALL_STAGING = YES
LIBEBML_LICENSE = LGPL-2.1+
LIBEBML_LICENSE_FILES = LICENSE.LGPL
LIBEBML_CPE_ID_VENDOR = matroska

$(eval $(cmake-package))
