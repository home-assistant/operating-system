################################################################################
#
# python-mbstrdecoder
#
################################################################################

PYTHON_MBSTRDECODER_VERSION = 1.0.1
PYTHON_MBSTRDECODER_SOURCE = mbstrdecoder-$(PYTHON_MBSTRDECODER_VERSION).tar.gz
PYTHON_MBSTRDECODER_SITE = https://files.pythonhosted.org/packages/b7/3b/2524dd4771dfca572269036fb08356715cb78a1c1c2a4dae3a810a86b777
PYTHON_MBSTRDECODER_SETUP_TYPE = setuptools
PYTHON_MBSTRDECODER_LICENSE = MIT
PYTHON_MBSTRDECODER_LICENSE_FILES = LICENSE

$(eval $(python-package))
