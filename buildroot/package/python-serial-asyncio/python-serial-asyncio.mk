################################################################################
#
# python-serial-asyncio
#
################################################################################

PYTHON_SERIAL_ASYNCIO_VERSION = 0.5
PYTHON_SERIAL_ASYNCIO_SOURCE = pyserial-asyncio-$(PYTHON_SERIAL_ASYNCIO_VERSION).tar.gz
PYTHON_SERIAL_ASYNCIO_SITE = https://files.pythonhosted.org/packages/e1/97/8dd1bf656796668ed4bd86058c815b130303a00a7b70cf79758e4918814a
PYTHON_SERIAL_ASYNCIO_LICENSE = BSD-3-Clause
PYTHON_SERIAL_ASYNCIO_LICENSE_FILES = LICENSE.txt
PYTHON_SERIAL_ASYNCIO_SETUP_TYPE = setuptools

$(eval $(python-package))
