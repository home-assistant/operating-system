################################################################################
#
# exfat-linux
#
################################################################################

EXFAT_LINUX_VERSION = 034f47d607c441e7fb5be3eb71d7a289ef76bc0c
EXFAT_LINUX_SITE = $(call github,arter97,exfat-linux,$(EXFAT_LINUX_VERSION))
EXFAT_LINUX_LICENSE = GPL-2.0
EXFAT_LINUX_LICENSE_FILES = LICENSE
EXFAT_LINUX_MODULE_MAKE_OPTS = CONFIG_EXFAT_FS=m

$(eval $(kernel-module))
$(eval $(generic-package))