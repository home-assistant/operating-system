################################################################################
#
# hailo10h-pci
#
################################################################################

HAILO10H_PCI_VERSION = v5.3.0
HAILO10H_PCI_SITE = $(call github,hailo-ai,hailort-drivers,$(HAILO10H_PCI_VERSION))
HAILO10H_PCI_LICENSE = GPL-2.0
HAILO10H_PCI_LICENSE_FILES = LICENSE
HAILO10H_PCI_MODULE_SUBDIRS = linux/pcie

$(eval $(kernel-module))
$(eval $(generic-package))
