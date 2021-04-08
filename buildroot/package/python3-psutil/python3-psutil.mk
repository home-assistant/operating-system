################################################################################
#
# python3-psutil
#
################################################################################

# Please keep in sync with package/python-psutil/python-psutil.mk
PYTHON3_PSUTIL_VERSION = 5.7.2
PYTHON3_PSUTIL_SOURCE = psutil-$(PYTHON3_PSUTIL_VERSION).tar.gz
PYTHON3_PSUTIL_SITE = https://files.pythonhosted.org/packages/aa/3e/d18f2c04cf2b528e18515999b0c8e698c136db78f62df34eee89cee205f1
PYTHON3_PSUTIL_SETUP_TYPE = setuptools
PYTHON3_PSUTIL_LICENSE = BSD-3-Clause
PYTHON3_PSUTIL_LICENSE_FILES = LICENSE
PYTHON3_PSUTIL_CPE_ID_VENDOR = psutil_project
PYTHON3_PSUTIL_CPE_ID_PRODUCT = psutil
HOST_PYTHON3_PSUTIL_DL_SUBDIR = python-psutil
HOST_PYTHON3_PSUTIL_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
