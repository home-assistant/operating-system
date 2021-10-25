################################################################################
#
# python-pip
#
################################################################################

PYTHON_PIP_VERSION = 20.0.2
PYTHON_PIP_SOURCE = pip-$(PYTHON_PIP_VERSION).tar.gz
PYTHON_PIP_SITE = https://files.pythonhosted.org/packages/8e/76/66066b7bc71817238924c7e4b448abdb17eb0c92d645769c223f9ace478f
PYTHON_PIP_SETUP_TYPE = setuptools
PYTHON_PIP_LICENSE = MIT
PYTHON_PIP_LICENSE_FILES = LICENSE.txt
PYTHON_PIP_CPE_ID_VENDOR = pypa
PYTHON_PIP_CPE_ID_PRODUCT = pip

#0001-Don-t-split-git-references-on-unicode-separators.patch
PYTHON_PIP_IGNORE_CVES += CVE-2021-3572

$(eval $(python-package))
