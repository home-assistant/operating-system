################################################################################
#
# python-crontab
#
################################################################################

PYTHON_CRONTAB_VERSION = 2.5.1
PYTHON_CRONTAB_SITE = https://files.pythonhosted.org/packages/1b/7e/fb78b96de58a49b8ef807c321870ef4de3de5928fd71a40a400aed714310
PYTHON_CRONTAB_SETUP_TYPE = setuptools
PYTHON_CRONTAB_LICENSE = LGPL-3.0+
PYTHON_CRONTAB_LICENSE_FILES = COPYING

$(eval $(python-package))
