################################################################################
#
# python-engineio
#
################################################################################

PYTHON_ENGINEIO_VERSION = 3.10.0
PYTHON_ENGINEIO_SITE = https://files.pythonhosted.org/packages/78/8e/c58cf2725fd17d65b9fe818b70aff4ccce4903b47aaee6f4321727a8b8bb
PYTHON_ENGINEIO_SETUP_TYPE = setuptools
PYTHON_ENGINEIO_LICENSE = MIT
PYTHON_ENGINEIO_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_PYTHON),y)
# only needed/valid for python 3.x
define PYTHON_ENGINEIO_RM_PY3_FILES
	rm -rf $(TARGET_DIR)/usr/lib/python*/site-packages/engineio/async_drivers \
		$(TARGET_DIR)/usr/lib/python*/site-packages/engineio/asyncio_*.py
endef

PYTHON_ENGINEIO_POST_INSTALL_TARGET_HOOKS += PYTHON_ENGINEIO_RM_PY3_FILES
endif

$(eval $(python-package))
