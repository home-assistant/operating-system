################################################################################
#
# mongoose
#
################################################################################

MONGOOSE_VERSION = 7.2
MONGOOSE_SITE = $(call github,cesanta,mongoose,$(MONGOOSE_VERSION))
MONGOOSE_LICENSE = GPL-2.0
MONGOOSE_LICENSE_FILES = LICENSE
MONGOOSE_CPE_ID_VENDOR = cesenta
MONGOOSE_INSTALL_STAGING = YES
# static library
MONGOOSE_INSTALL_TARGET = NO

MONGOOSE_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MONGOOSE_DEPENDENCIES += openssl
MONGOOSE_CFLAGS += -DMG_ENABLE_OPENSSL=1
else ifeq ($(BR2_PACKAGE_MBEDTLS),y)
MONGOOSE_DEPENDENCIES += mbedtls
MONGOOSE_CFLAGS += -DMG_ENABLE_MBEDTLS=1
endif

define MONGOOSE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CC) -c $(@D)/mongoose.c $(MONGOOSE_CFLAGS) -o $(@D)/mongoose.o
	$(TARGET_MAKE_ENV) $(TARGET_AR) rcs $(@D)/libmongoose.a $(@D)/mongoose.o
endef

define MONGOOSE_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/libmongoose.a \
		$(STAGING_DIR)/usr/lib/libmongoose.a
	$(INSTALL) -D -m 644 $(@D)/mongoose.h \
		$(STAGING_DIR)/usr/include/mongoose.h
endef

$(eval $(generic-package))
