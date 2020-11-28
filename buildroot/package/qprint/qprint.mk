################################################################################
#
# qprint
#
################################################################################

QPRINT_VERSION = 1.1
QPRINT_SITE = https://www.fourmilab.ch/webtools/qprint
QPRINT_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) install-bin
QPRINT_LICENSE = Public Domain
QPRINT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
