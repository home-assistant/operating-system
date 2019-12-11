################################################################################
#
# qemu-guest-agent
#
################################################################################

QEMU_GUEST_AGENT_VERSION = 3.1.1.1
QEMU_GUEST_AGENT_SOURCE = qemu-$(QEMU_GUEST_AGENT_VERSION).tar.xz
QEMU_GUEST_AGENT_SITE = http://download.qemu.org
QEMU_GUEST_AGENT_LICENSE = GPL-2.0, LGPL-2.1, MIT, BSD-3-Clause, BSD-2-Clause, Others/BSD-1c
QEMU_GUEST_AGENT_LICENSE_FILES = COPYING COPYING.LIB

QEMU_DEPENDENCIES = host-pkgconf libglib2 zlib pixman
QEMU_GUEST_AGENT_CONF_OPTS = --audio-drv-list= \
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
	--disable-guest-agent \
	--disable-nettle \
	--disable-gcrypt \
	--disable-curses \
	--disable-vnc \
	--disable-virtfs \
	--disable-brlapi \
	--disable-fdt \
	--disable-bluez \
	--disable-kvm \
	--disable-rdma \
	--disable-vde \
	--disable-netmap \
	--disable-cap-ng \
	--disable-attr \
	--disable-vhost-net \
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
	--disable-blobs \
	--disable-capstone \
	--disable-tools \
	--disable-tcg-interpreter \
	--enable-guest-agent

define OPENVMTOOLS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(D)/qemu-guest.service \
		$(TARGET_DIR)/usr/lib/systemd/system/qemu-guest.service
	$(INSTALL) -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/qemu-guest.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/qemu-guest.service
endef

$(eval $(autotools-package))
