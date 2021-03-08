################################################################################
#
# python3-ply
#
################################################################################

PYTHON3_PLY_VERSION = 3.11
PYTHON3_PLY_SOURCE = ply-$(PYTHON3_PLY_VERSION).tar.gz
PYTHON3_PLY_SITE = https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da
PYTHON3_PLY_SETUP_TYPE = setuptools
PYTHON3_PLY_LICENSE = BSD-3-Clause
PYTHON3_PLY_LICENSE_FILES = README.md

HOST_PYTHON3_PLY_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
