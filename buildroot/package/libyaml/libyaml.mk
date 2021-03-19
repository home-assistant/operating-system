################################################################################
#
# libyaml
#
################################################################################

LIBYAML_VERSION = 0.2.5
LIBYAML_SOURCE = yaml-$(LIBYAML_VERSION).tar.gz
LIBYAML_SITE = http://pyyaml.org/download/libyaml
LIBYAML_INSTALL_STAGING = YES
LIBYAML_LICENSE = MIT
LIBYAML_LICENSE_FILES = License
LIBYAML_CPE_ID_VENDOR = pyyaml

$(eval $(autotools-package))
$(eval $(host-autotools-package))
