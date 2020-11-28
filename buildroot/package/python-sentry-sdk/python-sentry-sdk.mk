################################################################################
#
# python-sentry-sdk
#
################################################################################

PYTHON_SENTRY_SDK_VERSION = 0.17.3
PYTHON_SENTRY_SDK_SOURCE = sentry-sdk-$(PYTHON_SENTRY_SDK_VERSION).tar.gz
PYTHON_SENTRY_SDK_SITE = https://files.pythonhosted.org/packages/64/7e/f1725d8649ef8f7d58cbec582157c454884238e59fef00b1707d555c7bea
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
