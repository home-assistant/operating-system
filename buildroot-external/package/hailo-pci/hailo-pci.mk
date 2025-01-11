HAILO_PCI_VERSION = v4.19.0
HAILO_PCI_SITE = $(call github,hailo-ai,hailort-drivers,$(HAILO_PCI_VERSION))
HAILO_PCI_LICENSE = GPL-2.0
HAILO_PCI_LICENSE_FILES = LICENSE
HAILO_PCI_MODULE_SUBDIRS = linux/pcie

$(eval $(kernel-module))
$(eval $(generic-package))
