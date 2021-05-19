################################################################################
#
# python-aioconsole
#
################################################################################

PYTHON_AIOCONSOLE_VERSION = 0.3.1
PYTHON_AIOCONSOLE_SOURCE = aioconsole-$(PYTHON_AIOCONSOLE_VERSION).tar.gz
PYTHON_AIOCONSOLE_SITE = https://files.pythonhosted.org/packages/5a/12/fce04ddc0a8ebd6482e5ec293d8bda47c9e05c82826b061f7b73523b8601
PYTHON_AIOCONSOLE_SETUP_TYPE = setuptools
PYTHON_AIOCONSOLE_LICENSE = GPL-3.0

$(eval $(python-package))
