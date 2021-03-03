################################################################################
#
# python-mwscrape
#
################################################################################

PYTHON_MWSCRAPE_VERSION = 568ccbe6e12dd6391277df02adf724ba0e5f9197
PYTHON_MWSCRAPE_SITE = $(call github,itkach,mwscrape,$(PYTHON_MWSCRAPE_VERSION))
PYTHON_MWSCRAPE_LICENSE = MPL-2.0
PYTHON_MWSCRAPE_LICENSE_FILES = LICENSE.txt
PYTHON_MWSCRAPE_SETUP_TYPE = distutils

$(eval $(python-package))
