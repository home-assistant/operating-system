################################################################################
#
# python-networkx
#
################################################################################

PYTHON_NETWORKX_VERSION = 2.4
PYTHON_NETWORKX_SOURCE = networkx-$(PYTHON_NETWORKX_VERSION).tar.gz
PYTHON_NETWORKX_SITE = https://pypi.python.org/packages/bf/63/7b579dd3b1c49ce6b7fd8f6f864038f255201410905dd183cf7f4a3845cf
PYTHON_NETWORKX_LICENSE = BSD-3-Clause
PYTHON_NETWORKX_LICENSE_FILES = LICENSE.txt
PYTHON_NETWORKX_CPE_ID_VENDOR = python
PYTHON_NETWORKX_CPE_ID_PRODUCT = networkx
PYTHON_NETWORKX_SETUP_TYPE = setuptools
HOST_PYTHON_NETWORKX_DEPENDENCIES = host-python3-decorator
HOST_PYTHON_NETWORKX_NEEDS_HOST_PYTHON = python3

$(eval $(python-package))
$(eval $(host-python-package))
