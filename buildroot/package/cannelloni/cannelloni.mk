################################################################################
#
# cannelloni
#
################################################################################

CANNELLONI_VERSION = 1.0.0
CANNELLONI_SITE = $(call github,mguentner,cannelloni,v$(CANNELLONI_VERSION))
CANNELLONI_LICENSE = GPL-2.0
CANNELLONI_LICENSE_FILES = gpl-2.0.txt
CANNELLONI_CONF_OPTS = -DCMAKE_CXX_FLAGS="-std=c++11"

ifeq ($(BR2_PACKAGE_LKSCTP_TOOLS),y)
CANNELLONI_CONF_OPTS += -DSCTP_SUPPORT=ON
CANNELLONI_DEPENDENCIES += lksctp-tools
else
CANNELLONI_CONF_OPTS += -DSCTP_SUPPORT=OFF
endif

$(eval $(cmake-package))
