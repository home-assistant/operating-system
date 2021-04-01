################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 3.0.12
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/32/e3/e7e9a9378321fdfc3eb55de151911dce968fa245d1f16d8c480c63ea4ed1
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
