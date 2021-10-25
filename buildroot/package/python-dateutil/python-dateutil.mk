################################################################################
#
# python-dateutil
#
################################################################################

PYTHON_DATEUTIL_VERSION = 2.8.2
PYTHON_DATEUTIL_SITE = https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9
PYTHON_DATEUTIL_SETUP_TYPE = setuptools
PYTHON_DATEUTIL_LICENSE = BSD-3-Clause
PYTHON_DATEUTIL_LICENSE_FILES = LICENSE
PYTHON_DATEUTIL_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
