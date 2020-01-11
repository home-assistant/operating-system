################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.1.15
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/a5/ea/a3424e68851acb44a1f8f823dc32ee3eb10b7fda474b03d527f7e666b443
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
