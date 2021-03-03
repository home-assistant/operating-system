################################################################################
#
# python-bleak
#
################################################################################

PYTHON_BLEAK_VERSION = 0.10.0
PYTHON_BLEAK_SOURCE = bleak-$(PYTHON_BLEAK_VERSION).tar.gz
PYTHON_BLEAK_SITE = https://files.pythonhosted.org/packages/80/37/c8c88709e4f1ca4636bf11c96d1ec046d7426cd02670ae80a3542280558b
PYTHON_BLEAK_SETUP_TYPE = setuptools
PYTHON_BLEAK_LICENSE = MIT
PYTHON_BLEAK_LICENSE_FILES = LICENSE

$(eval $(python-package))
