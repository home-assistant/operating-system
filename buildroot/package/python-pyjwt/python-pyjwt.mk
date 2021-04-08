################################################################################
#
# python-pyjwt
#
################################################################################

PYTHON_PYJWT_VERSION = 2.0.0
PYTHON_PYJWT_SOURCE = PyJWT-$(PYTHON_PYJWT_VERSION).tar.gz
PYTHON_PYJWT_SITE = https://files.pythonhosted.org/packages/14/6d/096dc269d105ba374d6bfd3ecb22b516795ca0572499820dadc8178d9ae1
PYTHON_PYJWT_SETUP_TYPE = setuptools
PYTHON_PYJWT_LICENSE = MIT
PYTHON_PYJWT_LICENSE_FILES = LICENSE
PYTHON_PYJWT_CPE_ID_VENDOR = pyjwt_project
PYTHON_PYJWT_CPE_ID_PRODUCT = pyjwt

$(eval $(python-package))
