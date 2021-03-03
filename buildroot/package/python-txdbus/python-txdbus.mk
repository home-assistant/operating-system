################################################################################
#
# python-txdbus
#
################################################################################

PYTHON_TXDBUS_VERSION = 1.1.2
PYTHON_TXDBUS_SOURCE = txdbus-$(PYTHON_TXDBUS_VERSION).tar.gz
PYTHON_TXDBUS_SITE = https://files.pythonhosted.org/packages/d6/ef/43377e975b8d37862fd1166a4998f908651f5e205ddc9bbd7a57c6e5b4b6
PYTHON_TXDBUS_SETUP_TYPE = setuptools
PYTHON_TXDBUS_LICENSE = MIT

$(eval $(python-package))
