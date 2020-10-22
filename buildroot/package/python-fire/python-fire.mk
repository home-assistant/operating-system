################################################################################
#
# python-fire
#
################################################################################

PYTHON_FIRE_VERSION = 0.2.1
PYTHON_FIRE_SOURCE = fire-$(PYTHON_FIRE_VERSION).tar.gz
PYTHON_FIRE_SITE = https://files.pythonhosted.org/packages/d9/69/faeaae8687f4de0f5973694d02e9d6c3eb827636a009157352d98de1129e
PYTHON_FIRE_SETUP_TYPE = setuptools
PYTHON_FIRE_LICENSE = Apache-2.0
PYTHON_FIRE_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_PYTHON),y)
# only needed/valid for python 3.x
define PYTHON_FIRE_RM_PY3_FILE
	rm -f $(TARGET_DIR)/usr/lib/python*/site-packages/fire/test_components_py3.py
endef

PYTHON_FIRE_POST_INSTALL_TARGET_HOOKS += PYTHON_FIRE_RM_PY3_FILE
endif

$(eval $(python-package))
