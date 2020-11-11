################################################################################
#
# sentry-native
#
################################################################################

SENTRY_NATIVE_VERSION = 0.4.1
SENTRY_NATIVE_SITE = $(call github,getsentry,sentry-native,$(SENTRY_NATIVE_VERSION))
SENTRY_NATIVE_LICENSE = MIT
SENTRY_NATIVE_LICENSE_FILES = LICENSE
SENTRY_NATIVE_DEPENDENCIES = libcurl google-breakpad
SENTRY_NATIVE_INSTALL_STAGING = YES

# Use the built system breakpad client instead of bundling
SENTRY_NATIVE_CONF_OPTS += -DSENTRY_BREAKPAD_SYSTEM=ON

$(eval $(cmake-package))
