################################################################################
#
# protobuf
#
################################################################################

# When bumping this package, make sure to also verify if the
# python-protobuf package still works and to update its hash,
# as they share the same version/site variables.
PROTOBUF_VERSION = 3.14.0
PROTOBUF_SOURCE = protobuf-cpp-$(PROTOBUF_VERSION).tar.gz
PROTOBUF_SITE = https://github.com/google/protobuf/releases/download/v$(PROTOBUF_VERSION)
PROTOBUF_LICENSE = BSD-3-Clause
PROTOBUF_LICENSE_FILES = LICENSE
PROTOBUF_CPE_ID_VENDOR = google

# N.B. Need to use host protoc during cross compilation.
PROTOBUF_DEPENDENCIES = host-protobuf
PROTOBUF_CONF_OPTS = --with-protoc=$(HOST_DIR)/bin/protoc

PROTOBUF_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
PROTOBUF_CXXFLAGS += -O0
endif

PROTOBUF_CONF_ENV = CXXFLAGS="$(PROTOBUF_CXXFLAGS)"

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
PROTOBUF_CONF_ENV += LIBS=-latomic
endif

PROTOBUF_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_ZLIB),y)
PROTOBUF_DEPENDENCIES += zlib
endif

define PROTOBUF_REMOVE_UNNECESSARY_TARGET_FILES
	rm -rf $(TARGET_DIR)/usr/bin/protoc
	rm -rf $(TARGET_DIR)/usr/lib/libprotoc.so*
endef

PROTOBUF_POST_INSTALL_TARGET_HOOKS += PROTOBUF_REMOVE_UNNECESSARY_TARGET_FILES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
