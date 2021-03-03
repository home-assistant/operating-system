################################################################################
#
# python3-markupsafe
#
################################################################################

PYTHON3_MARKUPSAFE_VERSION = 1.1.1
PYTHON3_MARKUPSAFE_SOURCE = MarkupSafe-$(PYTHON3_MARKUPSAFE_VERSION).tar.gz
PYTHON3_MARKUPSAFE_SITE = https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094
PYTHON3_MARKUPSAFE_SETUP_TYPE = setuptools
PYTHON3_MARKUPSAFE_LICENSE = BSD-3-Clause
PYTHON3_MARKUPSAFE_LICENSE_FILES = LICENSE.rst

HOST_PYTHON3_MARKUPSAFE_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
