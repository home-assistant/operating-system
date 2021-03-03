################################################################################
#
# python-colorama
#
################################################################################

PYTHON_COLORAMA_VERSION = 0.4.4
PYTHON_COLORAMA_SOURCE = colorama-$(PYTHON_COLORAMA_VERSION).tar.gz
PYTHON_COLORAMA_SITE = https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe
PYTHON_COLORAMA_SETUP_TYPE = setuptools
PYTHON_COLORAMA_LICENSE = BSD-3-Clause
PYTHON_COLORAMA_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
