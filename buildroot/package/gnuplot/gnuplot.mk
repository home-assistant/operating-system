################################################################################
#
# gnuplot
#
################################################################################

GNUPLOT_VERSION = 5.4.1
GNUPLOT_SITE = http://downloads.sourceforge.net/project/gnuplot/gnuplot/$(GNUPLOT_VERSION)
GNUPLOT_LICENSE = gnuplot license (open source)
GNUPLOT_LICENSE_FILES = Copyright
GNUPLOT_CPE_ID_VENDOR = gnuplot_project

GNUPLOT_AUTORECONF = YES

GNUPLOT_CONF_OPTS = \
	--without-x \
	--disable-raise-console \
	--disable-mouse \
	--without-tutorial \
	--disable-demo \
	--without-row-help \
	--disable-history-file \
	--disable-wxwidgets \
	--without-lua \
	--without-latex \
	--without-cairo

# relocation truncated to fit: R_68K_GOT16O
ifeq ($(BR2_m68k_cf),y)
GNUPLOT_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -mxgot"
endif

ifeq ($(BR2_PACKAGE_GD)$(BR2_PACKAGE_LIBPNG),yy)
GNUPLOT_CONF_OPTS += --with-gd
GNUPLOT_DEPENDENCIES += host-pkgconf gd
else
GNUPLOT_CONF_OPTS += --without-gd
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
GNUPLOT_CONF_OPTS += --with-readline=gnu
GNUPLOT_DEPENDENCIES += readline
else
GNUPLOT_CONF_OPTS += --without-readline
endif

# Remove Javascript scripts, lua scripts, PostScript files
define GNUPLOT_REMOVE_UNNEEDED_FILES
	$(RM) -rf $(TARGET_DIR)/usr/share/gnuplot
endef

GNUPLOT_POST_INSTALL_TARGET_HOOKS += GNUPLOT_REMOVE_UNNEEDED_FILES

$(eval $(autotools-package))
