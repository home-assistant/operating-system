################################################################################
#
# python-backcall
#
################################################################################

PYTHON_BACKCALL_VERSION = 0.2.0
PYTHON_BACKCALL_SOURCE = backcall-$(PYTHON_BACKCALL_VERSION).tar.gz
PYTHON_BACKCALL_SITE = https://files.pythonhosted.org/packages/a2/40/764a663805d84deee23043e1426a9175567db89c8b3287b5c2ad9f71aa93
PYTHON_BACKCALL_SETUP_TYPE = distutils
PYTHON_BACKCALL_LICENSE = BSD-3-Clause
PYTHON_BACKCALL_LICENSE_FILES = LICENSE

$(eval $(python-package))
