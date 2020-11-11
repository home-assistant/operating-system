################################################################################
#
# bcm2835
#
################################################################################

BCM2835_VERSION = 1.65
BCM2835_SITE = http://www.airspayce.com/mikem/bcm2835
BCM2835_LICENSE = GPL-3.0
BCM2835_LICENSE_FILES = COPYING
BCM2835_INSTALL_STAGING = YES

# disable doxygen doc generation
BCM2835_CONF_ENV = ac_cv_prog_DOXYGEN=/bin/true

$(eval $(autotools-package))
