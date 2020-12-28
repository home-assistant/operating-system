################################################################################
#
# kismet
#
################################################################################

KISMET_VERSION = 2020-09-R4
KISMET_SOURCE = kismet-$(KISMET_VERSION).tar.xz
KISMET_SITE = http://www.kismetwireless.net/code
KISMET_DEPENDENCIES = \
	host-pkgconf \
	libpcap \
	$(if $(BR2_PACKAGE_LIBNL),libnl) \
	$(if $(BR2_PACKAGE_PROTOBUF),protobuf) \
	protobuf-c \
	sqlite \
	zlib
KISMET_LICENSE = GPL-2.0+
KISMET_LICENSE_FILES = LICENSE
# We're patching configure.ac
KISMET_AUTORECONF = YES
KISMET_CONF_OPTS = --disable-debuglibs

KISMET_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
KISMET_CXXFLAGS += -O0
endif

KISMET_CONF_ENV += CXXFLAGS="$(KISMET_CXXFLAGS)"

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
KISMET_CONF_ENV += LIBS=-latomic
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
KISMET_DEPENDENCIES += libcap
KISMET_CONF_OPTS += --enable-libcap
else
KISMET_CONF_OPTS += --disable-libcap
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
KISMET_DEPENDENCIES += libusb
KISMET_CONF_OPTS += --enable-libusb
else
KISMET_CONF_OPTS += --disable-libusb
endif

ifeq ($(BR2_PACKAGE_LM_SENSORS),y)
KISMET_DEPENDENCIES += lm-sensors
KISMET_CONF_OPTS += --enable-lmsensors
else
KISMET_CONF_OPTS += --disable-lmsensors
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
KISMET_DEPENDENCIES += pcre
KISMET_CONF_OPTS += --enable-pcre
else
KISMET_CONF_OPTS += --disable-pcre
endif

ifeq ($(BR2_PACKAGE_KISMET_PYTHON_TOOLS),y)
KISMET_DEPENDENCIES += python3 python-setuptools
KISMET_CONF_OPTS += \
	--enable-python-tools \
	--with-python-interpreter=$(HOST_DIR)/bin/python$(PYTHON3_VERSION_MAJOR)
else
KISMET_CONF_OPTS += --disable-python-tools
endif

KISMET_INSTALL_TARGET_OPTS += \
	DESTDIR=$(TARGET_DIR) \
	INSTUSR=$(shell id -u) \
	INSTGRP=$(shell id -g) \
	SUIDGROUP=$(shell id -g)

ifeq ($(BR2_PACKAGE_KISMET_SERVER),y)
KISMET_DEPENDENCIES += libmicrohttpd
KISMET_CONF_OPTS += --disable-capture-tools-only
KISMET_INSTALL_TARGET_OPTS += install
else
KISMET_CONF_OPTS += --enable-capture-tools-only
KISMET_INSTALL_TARGET_OPTS += binsuidinstall
endif

$(eval $(autotools-package))
