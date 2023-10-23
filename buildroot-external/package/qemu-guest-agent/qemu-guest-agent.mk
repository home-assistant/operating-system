################################################################################
#
# qemu-guest-agent
#
################################################################################

QEMU_GUEST_AGENT_VERSION = 8.0.5
QEMU_GUEST_AGENT_SOURCE = qemu-$(QEMU_GUEST_AGENT_VERSION).tar.xz
QEMU_GUEST_AGENT_SITE = http://download.qemu.org
QEMU_GUEST_AGENT_LICENSE = GPL-2.0, LGPL-2.1, MIT, BSD-3-Clause, BSD-2-Clause, Others/BSD-1c
QEMU_GUEST_AGENT_LICENSE_FILES = COPYING COPYING.LIB
# NOTE: there is no top-level license file for non-(L)GPL licenses;
#       the non-(L)GPL license texts are specified in the affected
#       individual source files.

QEMU_GUEST_AGENT_DEPENDENCIES = host-pkgconf libglib2 zlib

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
			--meson=$(HOST_DIR)/bin/meson \
			--ninja=$(HOST_DIR)/bin/ninja \
			--disable-kvm \
			--disable-linux-user \
			--disable-linux-aio \
			--disable-xen \
			--disable-docs \
			--disable-curl \
			--disable-gnutls \
			--disable-gtk \
			--disable-vte \
			--disable-vnc-jpeg \
			--disable-opengl \
			--disable-usb-redir \
			--disable-sdl \
			--disable-system \
			--disable-user \
			--disable-nettle \
			--disable-gcrypt \
			--disable-curses \
			--disable-vnc \
			--disable-virtfs \
			--disable-brlapi \
			--disable-fdt \
			--disable-kvm \
			--disable-rdma \
			--disable-vde \
			--disable-netmap \
			--disable-cap-ng \
			--disable-attr \
			--disable-vhost-net \
			--disable-vhost-user \
			--disable-spice \
			--disable-rbd \
			--disable-libiscsi \
			--disable-libnfs \
			--disable-smartcard \
			--disable-libusb \
			--disable-usb-redir \
			--disable-lzo \
			--disable-snappy \
			--disable-bzip2 \
			--disable-seccomp \
			--disable-coroutine-pool \
			--disable-glusterfs \
			--disable-tpm \
			--disable-numa \
			--disable-capstone \
			--disable-tcg-interpreter \
			--enable-tools \
			--enable-guest-agent
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
