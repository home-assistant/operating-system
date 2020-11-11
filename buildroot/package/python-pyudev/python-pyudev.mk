################################################################################
#
# python-pyudev
#
################################################################################

PYTHON_PYUDEV_VERSION = 0.22.0
PYTHON_PYUDEV_SOURCE = pyudev-$(PYTHON_PYUDEV_VERSION).tar.gz
PYTHON_PYUDEV_SITE = https://files.pythonhosted.org/packages/72/c8/4660d815a79b1d42c409012aaa10ebd6b07a47529b4cb6880f27a24bd646
PYTHON_PYUDEV_LICENSE = LGPL-2.1+
PYTHON_PYUDEV_LICENSE_FILES = COPYING
PYTHON_PYUDEV_SETUP_TYPE = setuptools

$(eval $(python-package))
