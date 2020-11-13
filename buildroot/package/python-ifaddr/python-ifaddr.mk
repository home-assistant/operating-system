################################################################################
#
# python-ifaddr
#
################################################################################

PYTHON_IFADDR_VERSION = 0.1.7
PYTHON_IFADDR_SOURCE = ifaddr-$(PYTHON_IFADDR_VERSION).tar.gz
PYTHON_IFADDR_SITE = https://files.pythonhosted.org/packages/3d/fc/4ce147e3997cd0ea470ad27112087545cf83bf85015ddb3054673cb471bb
PYTHON_IFADDR_SETUP_TYPE = setuptools
PYTHON_IFADDR_LICENSE = MIT
PYTHON_IFADDR_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
