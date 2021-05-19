################################################################################
#
# python-httplib2
#
################################################################################

PYTHON_HTTPLIB2_VERSION = 0.19.1
PYTHON_HTTPLIB2_SOURCE = httplib2-$(PYTHON_HTTPLIB2_VERSION).tar.gz
PYTHON_HTTPLIB2_SITE = https://files.pythonhosted.org/packages/ed/cd/533a1e9e04671bcee5d2854b4f651a3fab9586d698de769d93b05ee2bff1
PYTHON_HTTPLIB2_SETUP_TYPE = setuptools
PYTHON_HTTPLIB2_LICENSE = MIT
PYTHON_HTTPLIB2_LICENSE_FILES = LICENSE
PYTHON_HTTPLIB2_CPE_ID_VENDOR = httplib2_project
PYTHON_HTTPLIB2_CPE_ID_PRODUCT = httplib2

$(eval $(python-package))
