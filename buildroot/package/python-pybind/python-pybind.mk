################################################################################
#
# python-pybind
#
################################################################################

PYTHON_PYBIND_VERSION = 2.5.0
PYTHON_PYBIND_SITE = $(call github,pybind,pybind11,v$(PYTHON_PYBIND_VERSION))
PYTHON_PYBIND_LICENSE = BSD-3-Clause
PYTHON_PYBIND_LICENSE_FILES = LICENSE
PYTHON_PYBIND_SETUP_TYPE = setuptools

$(eval $(python-package))
