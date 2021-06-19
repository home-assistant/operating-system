################################################################################
#
# python-requests
#
################################################################################

# Please keep in sync with package/python3-requests/python3-requests.mk
PYTHON_REQUESTS_VERSION = 2.25.1
PYTHON_REQUESTS_SOURCE = requests-$(PYTHON_REQUESTS_VERSION).tar.gz
PYTHON_REQUESTS_SITE = https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b
PYTHON_REQUESTS_SETUP_TYPE = setuptools
PYTHON_REQUESTS_LICENSE = Apache-2.0
PYTHON_REQUESTS_LICENSE_FILES = LICENSE
PYTHON_REQUESTS_CPE_ID_VENDOR = python
PYTHON_REQUESTS_CPE_ID_PRODUCT = requests

$(eval $(python-package))
