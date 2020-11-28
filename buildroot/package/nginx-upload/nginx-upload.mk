################################################################################
#
# nginx-upload
#
################################################################################

NGINX_UPLOAD_VERSION = 4423994c7d8fb491d95867f6af968585d949e7a9
NGINX_UPLOAD_SITE = $(call github,vkholodkov,nginx-upload-module,$(NGINX_UPLOAD_VERSION))
NGINX_UPLOAD_LICENSE = BSD-3-Clause
NGINX_UPLOAD_LICENSE_FILES = LICENCE
NGINX_UPLOAD_DEPENDENCIES = openssl

$(eval $(generic-package))
