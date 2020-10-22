################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 3.0.10
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/f4/09/d7c995b128bec61233cfea0e5fa40e442cae54c127b4b2b0881e1fdd0023
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
