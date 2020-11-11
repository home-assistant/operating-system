################################################################################
#
# python-ipdb
#
################################################################################

PYTHON_IPDB_VERSION = 0.13.2
PYTHON_IPDB_SOURCE = ipdb-$(PYTHON_IPDB_VERSION).tar.gz
PYTHON_IPDB_SITE = https://files.pythonhosted.org/packages/2c/bb/a3e1a441719ebd75c6dac8170d3ddba884b7ee8a5c0f9aefa7297386627a
PYTHON_IPDB_SETUP_TYPE = setuptools
PYTHON_IPDB_LICENSE = BSD-3-Clause
PYTHON_IPDB_LICENSE_FILES = COPYING.txt

$(eval $(python-package))
