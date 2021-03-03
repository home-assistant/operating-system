################################################################################
#
# python-thrift
#
################################################################################

PYTHON_THRIFT_VERSION = 0.13.0
PYTHON_THRIFT_SOURCE = thrift-$(PYTHON_THRIFT_VERSION).tar.gz
PYTHON_THRIFT_SITE = https://files.pythonhosted.org/packages/97/1e/3284d19d7be99305eda145b8aa46b0c33244e4a496ec66440dac19f8274d
PYTHON_THRIFT_SETUP_TYPE = setuptools
PYTHON_THRIFT_LICENSE = Apache-2.0
PYTHON_THRIFT_LICENSE_FILES = LICENSE

$(eval $(python-package))
