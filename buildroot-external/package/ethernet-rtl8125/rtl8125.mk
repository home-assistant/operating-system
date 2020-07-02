################################################################################
#
# rtl8125
#
################################################################################

RTL8125_LICENSE = GPL-2.0
RTL8125_LICENSE_FILES = COPYING
RTL8125_SOURCE = 9.003.05-1.tar.gz
RTL8125_MODULE_SUBDIRS = src
RTL8125_SITE = https://github.com/awesometic/realtek-r8125-dkms/archive

$(eval $(kernel-module))
$(eval $(generic-package))
