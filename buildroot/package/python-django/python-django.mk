################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.2.9
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/2c/0d/2aa8e58c791d2aa65658fa26f2b035a9da13a6a34d1b2d991912c8a33729
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
