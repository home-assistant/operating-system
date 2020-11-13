################################################################################
#
# circus
#
################################################################################

CIRCUS_VERSION = 0.16.1
CIRCUS_SITE = https://files.pythonhosted.org/packages/09/8a/44a0b6b35ecf5dcf22bf51e4bcf188ec9e7ab9dd4c14330ba1b8bea51102
CIRCUS_SETUP_TYPE = setuptools
CIRCUS_LICENSE = Apache-2.0
CIRCUS_LICENSE_FILES = LICENSE

$(eval $(python-package))
