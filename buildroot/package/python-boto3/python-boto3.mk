################################################################################
#
# python-boto3
#
################################################################################

PYTHON_BOTO3_VERSION = 1.16.50
PYTHON_BOTO3_SOURCE = boto3-$(PYTHON_BOTO3_VERSION).tar.gz
PYTHON_BOTO3_SITE = https://files.pythonhosted.org/packages/c8/c6/b4d9547a493ac2837f296f4a004dff6e7136cf6750d181769b8a61d63813
PYTHON_BOTO3_SETUP_TYPE = setuptools
PYTHON_BOTO3_LICENSE = Apache-2.0
PYTHON_BOTO3_LICENSE_FILES = LICENSE

$(eval $(python-package))
