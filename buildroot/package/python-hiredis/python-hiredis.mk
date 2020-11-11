################################################################################
#
# python-hiredis
#
################################################################################

PYTHON_HIREDIS_VERSION = 1.1.0
PYTHON_HIREDIS_SOURCE = hiredis-$(PYTHON_HIREDIS_VERSION).tar.gz
PYTHON_HIREDIS_SITE = https://files.pythonhosted.org/packages/3d/9f/abc69e73055f73d42ddf9c46b3e01a08b9e74b579b8fc413cbd31112a749
PYTHON_HIREDIS_SETUP_TYPE = setuptools
PYTHON_HIREDIS_LICENSE = BSD-3-Clause
PYTHON_HIREDIS_LICENSE_FILES = COPYING vendor/hiredis/COPYING

$(eval $(python-package))
