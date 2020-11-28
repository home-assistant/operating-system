################################################################################
#
# c-ares
#
################################################################################

C_ARES_VERSION = 1.17.0
C_ARES_SITE = http://c-ares.haxx.se/download
C_ARES_INSTALL_STAGING = YES
C_ARES_CONF_OPTS = --with-random=/dev/urandom
C_ARES_LICENSE = MIT
C_ARES_LICENSE_FILES = LICENSE.md
# We're patching src/lib/Makefile.am
C_ARES_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
