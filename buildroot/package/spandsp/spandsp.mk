################################################################################
#
# spandsp
#
################################################################################

SPANDSP_VERSION = 3.0.0-6ec23e5a7e
SPANDSP_SITE = https://files.freeswitch.org/downloads/libs
SPANDSP_LICENSE = LGPL-2.1 (library), GPL-2.0 (test suite)
SPANDSP_LICENSE_FILES = COPYING
# We're patching configure.ac
SPANDSP_AUTORECONF = YES

SPANDSP_DEPENDENCIES = tiff host-pkgconf
SPANDSP_INSTALL_STAGING = YES
SPANDSP_CONF_ENV = LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs libtiff-4`"

# MMX on i686 raises a build failure
SPANDSP_CONF_OPTS = \
	--disable-builtin-tiff \
	$(if $(BR2_x86_64),--enable-mmx,--disable-mmx) \
	$(if $(BR2_X86_CPU_HAS_SSE),--enable-sse,--disable-sse) \
	$(if $(BR2_X86_CPU_HAS_SSE2),--enable-sse2,--disable-sse2) \
	$(if $(BR2_X86_CPU_HAS_SSE3),--enable-sse3,--disable-sse3) \
	$(if $(BR2_X86_CPU_HAS_SSSE3),--enable-ssse3,--disable-ssse3) \
	$(if $(BR2_X86_CPU_HAS_SSE4),--enable-sse4-1,--disable-sse4-1) \
	$(if $(BR2_X86_CPU_HAS_SSE42),--enable-sse4-2,--disable-sse4-2)

$(eval $(autotools-package))
