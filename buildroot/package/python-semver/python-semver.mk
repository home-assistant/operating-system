################################################################################
#
# python-semver
#
################################################################################

PYTHON_SEMVER_VERSION = 2.10.2
PYTHON_SEMVER_SOURCE = semver-$(PYTHON_SEMVER_VERSION).tar.gz
PYTHON_SEMVER_SITE = https://files.pythonhosted.org/packages/aa/e8/cb894f70a52887f001aff5f264f68272c21fa58268495aca17df396c161f
PYTHON_SEMVER_SETUP_TYPE = setuptools
PYTHON_SEMVER_LICENSE = BSD-3-Clause
PYTHON_SEMVER_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
