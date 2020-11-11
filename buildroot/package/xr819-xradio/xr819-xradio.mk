################################################################################
#
# xr819-xradio
#
################################################################################

XR819_XRADIO_VERSION = 6bf0e2e21c80456e2a3d4ad1267caecde7165871
XR819_XRADIO_SITE = $(call github,fifteenhex,xradio,$(XR819_XRADIO_VERSION))
XR819_XRADIO_LICENSE = GPL-2.0
XR819_XRADIO_LICENSE_FILES = LICENSE

$(eval $(kernel-module))
$(eval $(generic-package))
