#############################################################
#
# apparmor
#
#############################################################
APPARMOR_VERSION = 2.13.0
APPARMOR_SOURCE  = apparmor-2.13.tar.gz
APPARMOR_SITE    = https://launchpad.net/apparmor/2.13/${APPARMOR_VERSION}/+download
APPARMOR_LICENSE = GPL-2
APPARMOR_LICENSE_FILES = LICENSE
APPARMOR_INSTALL_STAGING = YES

APPARMOR_CONF_OPTS = --prefix=/usr

$(eval $(generic-package))
