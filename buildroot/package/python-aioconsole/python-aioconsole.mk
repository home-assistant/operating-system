################################################################################
#
# python-aioconsole
#
################################################################################

PYTHON_AIOCONSOLE_VERSION = 0.3.2
PYTHON_AIOCONSOLE_SOURCE = aioconsole-$(PYTHON_AIOCONSOLE_VERSION).tar.gz
PYTHON_AIOCONSOLE_SITE = https://files.pythonhosted.org/packages/7a/b2/747ab3cb965596cd84c5159941613d901d8771acad3c51c4f5da362aa9f0
PYTHON_AIOCONSOLE_SETUP_TYPE = setuptools
PYTHON_AIOCONSOLE_LICENSE = GPL-3.0
PYTHON_AIOCONSOLE_LICENSE_FILES = LICENSE

$(eval $(python-package))
