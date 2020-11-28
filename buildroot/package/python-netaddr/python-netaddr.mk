################################################################################
#
# python-netaddr
#
################################################################################

PYTHON_NETADDR_VERSION = 0.8.0
PYTHON_NETADDR_SOURCE = netaddr-$(PYTHON_NETADDR_VERSION).tar.gz
PYTHON_NETADDR_SITE = https://pypi.python.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587
PYTHON_NETADDR_LICENSE = BSD-3-Clause
PYTHON_NETADDR_LICENSE_FILES = LICENSE
PYTHON_NETADDR_SETUP_TYPE = setuptools

$(eval $(python-package))
