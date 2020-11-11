################################################################################
#
# harfbuzz
#
################################################################################

HARFBUZZ_VERSION = 2.7.2
HARFBUZZ_SITE = https://github.com/harfbuzz/harfbuzz/releases/download/$(HARFBUZZ_VERSION)
HARFBUZZ_SOURCE = harfbuzz-$(HARFBUZZ_VERSION).tar.xz
HARFBUZZ_LICENSE = MIT, ISC (ucdn library)
HARFBUZZ_LICENSE_FILES = COPYING
HARFBUZZ_INSTALL_STAGING = YES
HARFBUZZ_CONF_OPTS = \
	-Dfontconfig=disabled \
	-Dgdi=disabled \
	-Ddirectwrite=disabled \
	-Dcoretext=disabled \
	-Dtests=disabled \
	-Ddocs=disabled \
	-Dbenchmark=disabled \
	-Dicu_builtin=false \
	-Dexperimental_api=false \
	-Dfuzzer_ldflags=""

# freetype & glib2 support required by host-pango
HOST_HARFBUZZ_DEPENDENCIES = \
	host-freetype \
	host-libglib2
HOST_HARFBUZZ_CONF_OPTS = \
	-Dglib=enabled \
	-Dgobject=disabled \
	-Dcairo=disabled \
	-Dfontconfig=disabled \
	-Dicu=disabled \
	-Dgraphite=disabled \
	-Dfreetype=enabled \
	-Dgdi=disabled \
	-Ddirectwrite=disabled \
	-Dcoretext=disabled \
	-Dtests=disabled \
	-Dintrospection=disabled \
	-Ddocs=disabled \
	-Dbenchmark=disabled \
	-Dicu_builtin=false \
	-Dexperimental_api=false \
	-Dfuzzer_ldflags=""

ifeq ($(BR2_PACKAGE_CAIRO),y)
HARFBUZZ_DEPENDENCIES += cairo
HARFBUZZ_CONF_OPTS += -Dcairo=enabled
else
HARFBUZZ_CONF_OPTS += -Dcairo=disabled
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
HARFBUZZ_DEPENDENCIES += freetype
HARFBUZZ_CONF_OPTS += -Dfreetype=enabled
else
HARFBUZZ_CONF_OPTS += -Dfreetype=disabled
endif

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
HARFBUZZ_DEPENDENCIES += gobject-introspection
HARFBUZZ_CONF_OPTS += \
	-Dgobject=enabled \
	-Dintrospection=enabled
else
HARFBUZZ_CONF_OPTS += \
	-Dgobject=disabled \
	-Dintrospection=disabled
endif

ifeq ($(BR2_PACKAGE_GRAPHITE2),y)
HARFBUZZ_DEPENDENCIES += graphite2
HARFBUZZ_CONF_OPTS += -Dgraphite=enabled
else
HARFBUZZ_CONF_OPTS += -Dgraphite=disabled
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
HARFBUZZ_DEPENDENCIES += libglib2
HARFBUZZ_CONF_OPTS += -Dglib=enabled
else
HARFBUZZ_CONF_OPTS += -Dglib=disabled
endif

ifeq ($(BR2_PACKAGE_ICU),y)
HARFBUZZ_DEPENDENCIES += icu
HARFBUZZ_CONF_OPTS += -Dicu=enabled
else
HARFBUZZ_CONF_OPTS += -Dicu=disabled
endif

$(eval $(meson-package))
$(eval $(host-meson-package))
