################################################################################
#
# python-txtorcon
#
################################################################################

PYTHON_TXTORCON_VERSION = 19.1.0
PYTHON_TXTORCON_SOURCE = txtorcon-$(PYTHON_TXTORCON_VERSION).tar.gz
PYTHON_TXTORCON_SITE = https://files.pythonhosted.org/packages/8c/26/d5b2fba4ffbcb23957ff2cee4d7d0a2d667372b9eb04807058bd561c8e8f
PYTHON_TXTORCON_SETUP_TYPE = setuptools
PYTHON_TXTORCON_LICENSE = MIT
PYTHON_TXTORCON_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_PYTHON),y)
# only needed/valid for python 3.x
define PYTHON_TXTORCON_RM_PY3_FILE
	rm -f $(TARGET_DIR)/usr/lib/python*/site-packages/txtorcon/controller_py3.py
endef

PYTHON_TXTORCON_POST_INSTALL_TARGET_HOOKS += PYTHON_TXTORCON_RM_PY3_FILE
endif

$(eval $(python-package))
