################################################################################
#
# python-opcua-asyncio
#
################################################################################

PYTHON_OPCUA_ASYNCIO_VERSION = 0.8.4
PYTHON_OPCUA_ASYNCIO_SOURCE = opcua-asyncio-$(PYTHON_OPCUA_ASYNCIO_VERSION).tar.gz
PYTHON_OPCUA_ASYNCIO_SITE = $(call github,FreeOpcUa,opcua-asyncio,$(PYTHON_OPCUA_ASYNCIO_VERSION))
PYTHON_OPCUA_ASYNCIO_SETUP_TYPE = setuptools
PYTHON_OPCUA_ASYNCIO_LICENSE = LGPL-3.0+
PYTHON_OPCUA_ASYNCIO_LICENSE_FILES = COPYING

$(eval $(python-package))
