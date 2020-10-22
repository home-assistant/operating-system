################################################################################
#
# python-sentry-sdk
#
################################################################################

PYTHON_SENTRY_SDK_VERSION = 0.13.1
PYTHON_SENTRY_SDK_SOURCE = sentry-sdk-$(PYTHON_SENTRY_SDK_VERSION).tar.gz
PYTHON_SENTRY_SDK_SITE = https://files.pythonhosted.org/packages/e2/5f/1f5881e98746c16464d46ae9d6ccdd6ce3c01c7e13093ea8a7d917642ee7
PYTHON_SENTRY_SDK_SETUP_TYPE = setuptools
PYTHON_SENTRY_SDK_LICENSE = BSD-2-Clause
PYTHON_SENTRY_SDK_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_PYTHON),y)
# only needed/valid for python 3.x
define PYTHON_SENTRY_SDK_RM_PY3_FILES
	rm -f $(addprefix $(TARGET_DIR)/usr/lib/python*/site-packages/sentry_sdk/integrations/,\
		aiohttp.py asgi.py django/asgi.py sanic.py tornado.py)
endef

PYTHON_SENTRY_SDK_POST_INSTALL_TARGET_HOOKS += PYTHON_SENTRY_SDK_RM_PY3_FILES
endif

$(eval $(python-package))
