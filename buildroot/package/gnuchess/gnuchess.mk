################################################################################
#
# gnuchess
#
################################################################################

GNUCHESS_VERSION = 6.2.7
GNUCHESS_SITE = $(BR2_GNU_MIRROR)/chess
GNUCHESS_LICENSE = GPL-3.0+
GNUCHESS_LICENSE_FILES = COPYING
GNUCHESS_CPE_ID_VENDOR = gnu
GNUCHESS_CPE_ID_PRODUCT = chess

GNUCHESS_DEPENDENCIES = host-flex flex
GNUCHESS_DEPENDENCIES += $(if $(BR2_PACKAGE_READLINE),readline) \
	$(TARGET_NLS_DEPENDENCIES)

$(eval $(autotools-package))
