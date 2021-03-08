################################################################################
#
# python-aiohttp-remotes
#
################################################################################

PYTHON_AIOHTTP_REMOTES_VERSION = 1.0.0
PYTHON_AIOHTTP_REMOTES_SOURCE = aiohttp_remotes-$(PYTHON_AIOHTTP_REMOTES_VERSION).tar.gz
PYTHON_AIOHTTP_REMOTES_SITE = https://files.pythonhosted.org/packages/40/b6/1178bd1e26e88f9f29b7d1bbfae7b38d39ec9cf787d4685f83ade2e7aa7f
PYTHON_AIOHTTP_REMOTES_SETUP_TYPE = distutils
PYTHON_AIOHTTP_REMOTES_LICENSE = MIT
PYTHON_AIOHTTP_REMOTES_LICENSE_FILES = LICENSE

$(eval $(python-package))
