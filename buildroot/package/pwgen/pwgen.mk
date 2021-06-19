################################################################################
#
# pwgen
#
################################################################################

PWGEN_VERSION = 2.08
PWGEN_SITE = http://downloads.sourceforge.net/project/pwgen/pwgen/$(PWGEN_VERSION)
PWGEN_LICENSE = GPL-2.0
PWGEN_LICENSE_FILES = debian/copyright
PWGEN_CPE_ID_VENDOR = pwgen_project

$(eval $(autotools-package))
$(eval $(host-autotools-package))
