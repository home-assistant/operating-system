################################################################################
#
# python-lmdb
#
################################################################################

PYTHON_LMDB_VERSION = 0.99
PYTHON_LMDB_SOURCE = lmdb-$(PYTHON_LMDB_VERSION).tar.gz
PYTHON_LMDB_SITE = https://files.pythonhosted.org/packages/3b/66/aa6f3a3e338a3ca263575ce6f722c2fdcd21039a03b55c722e0ae0b216db
PYTHON_LMDB_LICENSE = OLDAP-2.8
PYTHON_LMDB_LICENSE_FILES = LICENSE
PYTHON_LMDB_SETUP_TYPE = setuptools
PYTHON_LMDB_DEPENDENCIES = host-python-cffi

$(eval $(python-package))
