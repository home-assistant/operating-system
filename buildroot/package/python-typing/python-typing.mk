################################################################################
#
# python-typing
#
################################################################################

PYTHON_TYPING_VERSION = 3.7.4.3
PYTHON_TYPING_SOURCE = typing-$(PYTHON_TYPING_VERSION).tar.gz
PYTHON_TYPING_SITE = https://files.pythonhosted.org/packages/05/d9/6eebe19d46bd05360c9a9aae822e67a80f9242aabbfc58b641b957546607
PYTHON_TYPING_SETUP_TYPE = setuptools
PYTHON_TYPING_LICENSE = Python-2.0, others
PYTHON_TYPING_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
