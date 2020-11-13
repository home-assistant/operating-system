################################################################################
#
# php-xdebug
#
################################################################################

PHP_XDEBUG_VERSION = 2.9.6
PHP_XDEBUG_SITE = $(call github,xdebug,xdebug,$(PHP_XDEBUG_VERSION))
PHP_XDEBUG_INSTALL_STAGING = YES
PHP_XDEBUG_LICENSE = Xdebug License (PHP-3.0-like)
PHP_XDEBUG_LICENSE_FILES = LICENSE
# phpize does the autoconf magic
PHP_XDEBUG_DEPENDENCIES = php host-autoconf
PHP_XDEBUG_CONF_OPTS = \
	--enable-xdebug \
	--with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-xdebug=$(STAGING_DIR)/usr

define PHP_XDEBUG_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_XDEBUG_PRE_CONFIGURE_HOOKS += PHP_XDEBUG_PHPIZE

$(eval $(autotools-package))
