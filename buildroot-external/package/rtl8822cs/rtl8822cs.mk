################################################################################
#
# Realtek RTL8822CS driver
#
################################################################################

RTL8822CS_VERSION = 42779c3f1aa28ff4d3004de760276b6d515efa0d
RTL8822CS_SITE = $(call github,adeepn,rtl88x2cs,$(RTL8822CS_VERSION))
RTL8822CS_LICENSE = Unknown
#RTL8822CS_LICENSE_FILES = COPYING
#RTL8822CS_MODULE_SUBDIRS = src


RTL8822CS_MODULE_MAKE_OPTS = \
	CONFIG_RTL8822CS=m \
	KVER=$(LINUX_VERSION_PROBED) \
	KSRC=$(LINUX_DIR)

$(eval $(kernel-module))
$(eval $(generic-package))
