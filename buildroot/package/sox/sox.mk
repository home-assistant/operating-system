################################################################################
#
# sox
#
################################################################################

SOX_VERSION = 7524160b29a476f7e87bc14fddf12d349f9a3c5e
SOX_SITE = git://git.code.sf.net/p/sox/code
SOX_SITE_METHOD = git
SOX_DEPENDENCIES = host-autoconf-archive host-pkgconf
SOX_LICENSE = GPL-2.0+ (sox binary), LGPL-2.1+ (libraries)
SOX_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL
SOX_CPE_ID_VENDOR = sound_exchange_project
SOX_CPE_ID_PRODUCT = sound_exchange
# From git and we're patching configure.ac
SOX_AUTORECONF = YES
SOX_AUTORECONF_OPTS = --include=$(HOST_DIR)/share/autoconf-archive
SOX_INSTALL_STAGING = YES

SOX_IGNORE_CVES += CVE-2017-11332 CVE-2017-11358 CVE-2017-11359 \
	CVE-2017-15370 CVE-2017-15371 CVE-2017-15372 CVE-2017-15642 \
	CVE-2017-18189 CVE-2019-8354 CVE-2019-8355 CVE-2019-8356 \
	CVE-2019-8357 CVE-2019-13590

SOX_CONF_OPTS = \
	--with-distro="Buildroot" \
	--disable-stack-protector

ifeq ($(BR2_PACKAGE_ALSA_LIB_PCM),y)
SOX_DEPENDENCIES += alsa-lib
SOX_CONF_OPTS += --enable-alsa
else
SOX_CONF_OPTS += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_FILE),y)
SOX_DEPENDENCIES += file
SOX_CONF_OPTS += --enable-magic
else
SOX_CONF_OPTS += --disable-magic
endif

ifeq ($(BR2_PACKAGE_FLAC),y)
SOX_DEPENDENCIES += flac
SOX_CONF_OPTS += --enable-flac
else
SOX_CONF_OPTS += --disable-flac
endif

ifeq ($(BR2_PACKAGE_LAME),y)
SOX_DEPENDENCIES += lame
SOX_CONF_OPTS += --with-lame
else
SOX_CONF_OPTS += --without-lame
endif

ifeq ($(BR2_PACKAGE_LIBAO),y)
SOX_DEPENDENCIES += libao
SOX_CONF_OPTS += --enable-ao
else
SOX_CONF_OPTS += --disable-ao
endif

ifeq ($(BR2_PACKAGE_LIBGSM),y)
SOX_DEPENDENCIES += libgsm
SOX_CONF_OPTS += --enable-gsm
else
SOX_CONF_OPTS += --disable-gsm
endif

ifeq ($(BR2_PACKAGE_LIBID3TAG),y)
SOX_DEPENDENCIES += libid3tag
SOX_CONF_OPTS += --with-id3tag
else
SOX_CONF_OPTS += --without-id3tag
endif

ifeq ($(BR2_PACKAGE_LIBMAD),y)
SOX_DEPENDENCIES += libmad
SOX_CONF_OPTS += --with-mad
else
SOX_CONF_OPTS += --without-mad
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
SOX_DEPENDENCIES += libpng
SOX_CONF_OPTS += --with-png
else
SOX_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
SOX_DEPENDENCIES += libsndfile
SOX_CONF_OPTS += --enable-sndfile
else
SOX_CONF_OPTS += --disable-sndfile
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
SOX_DEPENDENCIES += libvorbis
SOX_CONF_OPTS += --enable-oggvorbis
else
SOX_CONF_OPTS += --disable-oggvorbis
endif

ifeq ($(BR2_PACKAGE_OPENCORE_AMR),y)
SOX_DEPENDENCIES += opencore-amr
SOX_CONF_OPTS += --enable-amrwb --enable-amrnb
else
SOX_CONF_OPTS += --disable-amrwb --disable-amrnb
endif

ifeq ($(BR2_PACKAGE_OPUSFILE),y)
SOX_DEPENDENCIES += opusfile
SOX_CONF_OPTS += --enable-opus
else
SOX_CONF_OPTS += --disable-opus
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
SOX_DEPENDENCIES += pulseaudio
SOX_CONF_OPTS += --enable-pulseaudio
else
SOX_CONF_OPTS += --disable-pulseaudio
endif

ifeq ($(BR2_PACKAGE_TWOLAME),y)
SOX_DEPENDENCIES += twolame
SOX_CONF_OPTS += --with-twolame
else
SOX_CONF_OPTS += --without-twolame
endif

ifeq ($(BR2_PACKAGE_WAVPACK),y)
SOX_DEPENDENCIES += wavpack
SOX_CONF_OPTS += --enable-wavpack
else
SOX_CONF_OPTS += --disable-wavpack
endif

$(eval $(autotools-package))
