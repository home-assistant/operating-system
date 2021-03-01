################################################################################
#
# Realtek RTL8822CS driver
#
################################################################################

RTL8822CS_VERSION = d07a0daa29ef50a16f85fd2a5f43396e534f57a8
RTL8822CS_SITE = $(call github,jethome-ru,rtl88x2cs,$(RTL8822CS_VERSION))
RTL8822CS_LICENSE = GPL-2.0

RTL8822CS_MODULE_MAKE_OPTS = \
	CONFIG_RTL8822CS=m \
	KVER=$(LINUX_VERSION_PROBED) \
	KSRC=$(LINUX_DIR)

$(eval $(kernel-module))
$(eval $(generic-package))
