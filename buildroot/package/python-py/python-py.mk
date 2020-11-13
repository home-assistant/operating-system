################################################################################
#
# python-py
#
################################################################################

PYTHON_PY_VERSION = 1.9.0
PYTHON_PY_SOURCE = py-$(PYTHON_PY_VERSION).tar.gz
PYTHON_PY_SITE = https://files.pythonhosted.org/packages/97/a6/ab9183fe08f69a53d06ac0ee8432bc0ffbb3989c575cc69b73a0229a9a99
PYTHON_PY_DEPENDENCIES = host-python-setuptools-scm
PYTHON_PY_SETUP_TYPE = setuptools
PYTHON_PY_LICENSE = MIT
PYTHON_PY_LICENSE_FILES = LICENSE

$(eval $(python-package))
