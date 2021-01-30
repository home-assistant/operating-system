################################################################################
#
# Realtek RTL8822CS driver
#
################################################################################

RTL8822CS_VERSION = 65af8fc4a72aa6ebcb02fbe3a5ea6f6886eeaebe
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
