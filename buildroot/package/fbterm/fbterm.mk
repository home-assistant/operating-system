################################################################################
#
# fbterm
#
################################################################################

FBTERM_VERSION = 1.7.0
FBTERM_SITE = https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/fbterm
FBTERM_LICENSE = GPL-2.0+
FBTERM_LICENSE_FILES = COPYING
FBTERM_DEPENDENCIES = fontconfig liberation

ifeq ($(BR2_PACKAGE_GPM),y)
FBTERM_DEPENDENCIES += gpm
FBTERM_CONF_OPTS += --enable-gpm
else
FBTERM_CONF_OPTS += --disable-gpm
endif

$(eval $(autotools-package))
