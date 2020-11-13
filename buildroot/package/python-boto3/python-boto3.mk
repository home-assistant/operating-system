################################################################################
#
# python-boto3
#
################################################################################

PYTHON_BOTO3_VERSION = 1.9.210
PYTHON_BOTO3_SOURCE = boto3-$(PYTHON_BOTO3_VERSION).tar.gz
PYTHON_BOTO3_SITE = https://files.pythonhosted.org/packages/d3/ac/79093e14a5397096d1fe4a17329a8453cebed8629cbc434e2dad5fb75b65
PYTHON_BOTO3_SETUP_TYPE = setuptools
PYTHON_BOTO3_LICENSE = Apache-2.0
PYTHON_BOTO3_LICENSE_FILES = LICENSE

$(eval $(python-package))
