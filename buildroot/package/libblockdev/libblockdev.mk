################################################################################
#
# libblockdev
#
################################################################################

LIBBLOCKDEV_VERSION = 2.24
LIBBLOCKDEV_SITE = https://github.com/storaged-project/libblockdev/releases/download/$(LIBBLOCKDEV_VERSION)-1
LIBBLOCKDEV_LICENSE = LGPL-2.1
LIBBLOCKDEV_LICENSE_FILES = LICENSE
LIBBLOCKDEV_INSTALL_STAGING = YES
LIBBLOCKDEV_DEPENDENCIES = host-pkgconf libglib2 kmod udev
# 0001-Provide-replacement-function-for-strerror_l.patch
LIBBLOCKDEV_AUTORECONF = YES

LIBBLOCKDEV_CONF_OPTS = \
	--disable-introspection \
	--with-loop \
	--without-bcache \
	--without-btrfs \
	--without-dm \
	--without-dmraid \
	--without-escrow \
	--without-kbd \
	--without-lvm_dbus \
	--without-mpath \
	--without-nvdimm \
	--without-python2 \
	--without-python3 \
	--without-s390 \
	--without-tools \
	--without-vdo

ifeq ($(BR2_PACKAGE_LIBBLOCKDEV_CRYPTO),y)
LIBBLOCKDEV_DEPENDENCIES += cryptsetup
LIBBLOCKDEV_CONF_OPTS += --with-crypto
else
LIBBLOCKDEV_CONF_OPTS += --without-crypto
endif

ifeq ($(BR2_PACKAGE_LIBBLOCKDEV_FS),y)
LIBBLOCKDEV_DEPENDENCIES += parted util-linux
LIBBLOCKDEV_CONF_OPTS += --with-fs
else
LIBBLOCKDEV_CONF_OPTS += --without-fs
endif

ifeq ($(BR2_PACKAGE_LIBBLOCKDEV_LOOP),y)
LIBBLOCKDEV_CONF_OPTS += --with-loop
else
LIBBLOCKDEV_CONF_OPTS += --without-loop
endif

ifeq ($(BR2_PACKAGE_LIBBLOCKDEV_LVM2),y)
LIBBLOCKDEV_DEPENDENCIES += lvm2 parted
LIBBLOCKDEV_CONF_OPTS += --with-lvm
else
LIBBLOCKDEV_CONF_OPTS += --without-lvm
endif

ifeq ($(BR2_PACKAGE_LIBBLOCKDEV_MDRAID),y)
LIBBLOCKDEV_DEPENDENCIES += libbytesize
LIBBLOCKDEV_CONF_OPTS += --with-mdraid
else
LIBBLOCKDEV_CONF_OPTS += --without-mdraid
endif

ifeq ($(BR2_PACKAGE_LIBBLOCKDEV_PART),y)
LIBBLOCKDEV_DEPENDENCIES += parted
LIBBLOCKDEV_CONF_OPTS += --with-part
else
LIBBLOCKDEV_CONF_OPTS += --without-part
endif

ifeq ($(BR2_PACKAGE_LIBBLOCKDEV_SWAP),y)
LIBBLOCKDEV_DEPENDENCIES += util-linux
LIBBLOCKDEV_CONF_OPTS += --with-swap
else
LIBBLOCKDEV_CONF_OPTS += --without-swap
endif

$(eval $(autotools-package))
