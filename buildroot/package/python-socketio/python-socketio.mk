################################################################################
#
# python-socketio
#
################################################################################

PYTHON_SOCKETIO_VERSION = 4.3.1
PYTHON_SOCKETIO_SITE = https://files.pythonhosted.org/packages/36/87/e9128a4da04df991fbdb01f44dc4d6dd8f6c03bfd4d1f42dcd6779fd975a
PYTHON_SOCKETIO_SETUP_TYPE = setuptools
PYTHON_SOCKETIO_LICENSE = MIT
PYTHON_SOCKETIO_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_PYTHON),y)
# only needed/valid for python 3.x
define PYTHON_SOCKETIO_RM_PY3_FILES
	rm -f $(TARGET_DIR)/usr/lib/python*/site-packages/socketio/asgi.py \
		$(TARGET_DIR)/usr/lib/python*/site-packages/socketio/asyncio_*.py
endef

PYTHON_SOCKETIO_POST_INSTALL_TARGET_HOOKS += PYTHON_SOCKETIO_RM_PY3_FILES
endif

$(eval $(python-package))
