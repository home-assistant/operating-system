################################################################################
#
# Intel Network Adapter Driver for PCIe
#
################################################################################

INTEL_E1000E_VERSION = 3.8.7
INTEL_E1000E_LICENSE = GPL-2.0
INTEL_E1000E_LICENSE_FILES = COPYING
INTEL_E1000E_SOURCE = e1000e-$(INTEL_E1000E_VERSION).tar.gz
INTEL_E1000E_SITE = https://downloads.sourceforge.net/project/e1000/e1000e%20historic%20archive/$(INTEL_E1000E_VERSION)
INTEL_E1000E_MODULE_SUBDIRS = src

INTEL_E1000E_MODULE_MAKE_OPTS = \
	CONFIG_E1000E=m \
	KVER=$(LINUX_VERSION_PROBED) \
	KSRC=$(LINUX_DIR)

$(eval $(kernel-module))
$(eval $(generic-package))
