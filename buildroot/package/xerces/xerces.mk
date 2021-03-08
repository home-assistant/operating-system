################################################################################
#
# xerces
#
################################################################################

XERCES_VERSION = 3.2.3
XERCES_SOURCE = xerces-c-$(XERCES_VERSION).tar.xz
XERCES_SITE = http://archive.apache.org/dist/xerces/c/3/sources
XERCES_LICENSE = Apache-2.0
XERCES_LICENSE_FILES = LICENSE
XERCES_CPE_ID_VENDOR = apache
XERCES_CPE_ID_PRODUCT = xerces-c\+\+
XERCES_INSTALL_STAGING = YES

define XERCES_DISABLE_SAMPLES
	$(SED) 's/add_subdirectory(samples)//' $(@D)/CMakeLists.txt
endef

XERCES_POST_PATCH_HOOKS += XERCES_DISABLE_SAMPLES

ifeq ($(BR2_PACKAGE_ICU),y)
XERCES_DEPENDENCIES += icu
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
XERCES_CONF_ENV += LIBS=-liconv
XERCES_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_XERCES_ENABLE_NETWORK),y)
ifeq ($(BR2_PACKAGE_LIBCURL),y)
XERCES_CONF_OPTS += -Dnetwork-accessor=curl
XERCES_DEPENDENCIES += libcurl
else
XERCES_CONF_OPTS += -Dnetwork-accessor=socket
endif
else
XERCES_CONF_OPTS += -Dnetwork=OFF
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
XERCES_CONF_OPTS += -Dthreads=ON
else
XERCES_CONF_OPTS += -Dthreads=OFF
endif

$(eval $(cmake-package))
