#############################################################
#
# apparmor
#
#############################################################
APPARMOR_VERSION = 2.13.0
APPARMOR_SOURCE  = apparmor-2.13.tar.gz
APPARMOR_SITE    = https://launchpad.net/apparmor/2.13/${APPARMOR_VERSION}/+download
APPARMOR_CONF_OPTS = 
APPARMOR_DEPENDENCIES = 

$(eval $(autotools-package))
