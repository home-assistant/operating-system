################################################################################
#
# qemu-guest-agent
#
################################################################################

QEMU_GUEST_AGENT_VERSION = 10.2.2
QEMU_GUEST_AGENT_SOURCE = qemu-$(QEMU_GUEST_AGENT_VERSION).tar.xz
QEMU_GUEST_AGENT_SITE = https://download.qemu.org
QEMU_GUEST_AGENT_LICENSE = GPL-2.0, LGPL-2.1, MIT, BSD-3-Clause, BSD-2-Clause, Others/BSD-1c
QEMU_GUEST_AGENT_LICENSE_FILES = COPYING COPYING.LIB
# NOTE: there is no top-level license file for non-(L)GPL licenses;
#       the non-(L)GPL license texts are specified in the affected
#       individual source files.

QEMU_GUEST_AGENT_DEPENDENCIES = \
	host-pkgconf \
	host-meson \
	host-python3 \
	host-python-distlib \
	libglib2 \
	zlib

# Need the LIBS variable because librt and libm are
# not automatically pulled. :-(
QEMU_GUEST_AGENT_LIBS = -lrt -lm

#QEMU_GUEST_AGENT_OPTS =

QEMU_GUEST_AGENT_VARS = LIBTOOL=$(HOST_DIR)/bin/libtool

# Override CPP, as it expects to be able to call it like it'd
# call the compiler.
define QEMU_GUEST_AGENT_CONFIGURE_CMDS
	unset TARGET_DIR; \
	cd $(@D); \
		LIBS='$(QEMU_GUEST_AGENT_LIBS)' \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CPP="$(TARGET_CC) -E" \
		$(QEMU_GUEST_AGENT_VARS) \
		./configure \
			--prefix=/usr \
			--localstatedir=/var \
			--cross-prefix=$(TARGET_CROSS) \
			--audio-drv-list= \
			--python=$(HOST_DIR)/bin/python3 \
			--ninja=$(HOST_DIR)/bin/ninja \
			--disable-attr \
			--disable-bsd-user \
			--disable-brlapi \
			--disable-bzip2 \
			--disable-cap-ng \
			--disable-capstone \
			--disable-coroutine-pool \
			--disable-curl \
			--disable-curses \
			--disable-docs \
			--disable-fdt \
			--disable-gcrypt \
			--disable-glusterfs \
			--disable-gnutls \
			--disable-gtk \
			--disable-kvm \
			--disable-libiscsi \
			--disable-libnfs \
			--disable-libusb \
			--disable-linux-aio \
			--disable-linux-io-uring \
			--disable-linux-user \
			--disable-lzo \
			--disable-netmap \
			--disable-nettle \
			--disable-numa \
			--disable-opengl \
			--disable-rbd \
			--disable-rdma \
			--disable-sdl \
			--disable-seccomp \
			--disable-smartcard \
			--disable-snappy \
			--disable-spice \
			--disable-system \
			--disable-tcg-interpreter \
			--disable-tpm \
			--disable-usb-redir \
			--disable-vde \
			--disable-vhost-net \
			--disable-vhost-user \
			--disable-virtfs \
			--disable-vnc \
			--disable-vnc-jpeg \
			--disable-vte \
			--disable-xen \
			--enable-guest-agent \
			--enable-tools
endef

define QEMU_GUEST_AGENT_BUILD_CMDS
	unset TARGET_DIR; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QEMU_GUEST_AGENT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/qga/qemu-ga $(TARGET_DIR)/usr/libexec/qemu-ga
endef

define QEMU_GUEST_AGENT_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(QEMU_GUEST_AGENT_PKGDIR)/qemu-guest.service \
		$(TARGET_DIR)/usr/lib/systemd/system/qemu-guest.service
	$(INSTALL) -d $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs /usr/lib/systemd/system/qemu-guest.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/qemu-guest.service
endef

$(eval $(generic-package))
