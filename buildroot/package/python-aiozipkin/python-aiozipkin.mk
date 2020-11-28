################################################################################
#
# python-aiozipkin
#
################################################################################

PYTHON_AIOZIPKIN_VERSION = 0.7.1
PYTHON_AIOZIPKIN_SOURCE = aiozipkin-$(PYTHON_AIOZIPKIN_VERSION).tar.gz
PYTHON_AIOZIPKIN_SITE = https://files.pythonhosted.org/packages/9e/33/120925f90470b7f52f46e2b9f71caf2514e389f42b3ed3b62f6389baee95
PYTHON_AIOZIPKIN_SETUP_TYPE = setuptools
PYTHON_AIOZIPKIN_LICENSE = Apache-2.0
PYTHON_AIOZIPKIN_LICENSE_FILES = LICENSE

$(eval $(python-package))
