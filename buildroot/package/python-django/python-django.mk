################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 3.2.2
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/da/24/e2e6e534464f8e0bd010401f06d2cfc773141776d2952d6418d01c97f12c
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_CPE_ID_VENDOR = djangoproject
PYTHON_DJANGO_CPE_ID_PRODUCT = django
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
