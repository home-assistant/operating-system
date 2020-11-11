################################################################################
#
# mraa
#
################################################################################

MRAA_VERSION = 2.1.0
MRAA_SITE = $(call github,eclipse,mraa,v$(MRAA_VERSION))
MRAA_LICENSE = MIT
MRAA_LICENSE_FILES = COPYING
MRAA_INSTALL_STAGING = YES

ifeq ($(BR2_i386),y)
MRAA_ARCH = i386
else ifeq ($(BR2_x86_64),y)
MRAA_ARCH = x86_64
else ifeq ($(BR2_arm)$(BR2_armeb),y)
MRAA_ARCH = arm
else ifeq ($(BR2_aarch64)$(BR2_aarch64_be),y)
MRAA_ARCH = aarch64
else ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
MRAA_ARCH = mips
endif

# USBPLAT only makes sense with FTDI4222, which requires the ftd2xx library,
# which doesn't exist in buildroot
# Disable C++ as it is used only by FTDI4222 and tests
MRAA_CONF_OPTS += \
	-DBUILDARCH=$(MRAA_ARCH) \
	-DBUILDCPP=OFF \
	-DBUILDSWIG=OFF \
	-DUSBPLAT=OFF \
	-DFTDI4222=OFF \
	-DENABLEEXAMPLES=OFF \
	-DBUILDTESTS=OFF

ifeq ($(BR2_PACKAGE_JSON_C),y)
MRAA_CONF_OPTS += -DJSONPLAT=ON
MRAA_DEPENDENCIES += json-c
else
MRAA_CONF_OPTS += -DJSONPLAT=OFF
endif

$(eval $(cmake-package))
