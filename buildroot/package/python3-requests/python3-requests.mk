################################################################################
#
# python3-requests
#
################################################################################

# Please keep in sync with package/python-requests/python-requests.mk
PYTHON3_REQUESTS_VERSION = 2.25.1
PYTHON3_REQUESTS_SOURCE = requests-$(PYTHON3_REQUESTS_VERSION).tar.gz
PYTHON3_REQUESTS_SITE = https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b
PYTHON3_REQUESTS_SETUP_TYPE = setuptools
PYTHON3_REQUESTS_LICENSE = Apache-2.0
PYTHON3_REQUESTS_LICENSE_FILES = LICENSE
HOST_PYTHON3_REQUESTS_DL_SUBDIR = python-requests
HOST_PYTHON3_REQUESTS_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
