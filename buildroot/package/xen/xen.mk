################################################################################
#
# Xen
#
################################################################################

XEN_VERSION = 4.14.0
XEN_SITE = https://downloads.xenproject.org/release/xen/$(XEN_VERSION)
XEN_PATCH = \
	https://xenbits.xenproject.org/xsa/xsa333.patch \
	https://xenbits.xenproject.org/xsa/xsa334.patch \
	https://xenbits.xenproject.org/xsa/xsa336.patch \
	https://xenbits.xenproject.org/xsa/xsa337/xsa337-1.patch \
	https://xenbits.xenproject.org/xsa/xsa337/xsa337-2.patch \
	https://xenbits.xenproject.org/xsa/xsa338.patch \
	https://xenbits.xenproject.org/xsa/xsa339.patch \
	https://xenbits.xenproject.org/xsa/xsa340.patch \
	https://xenbits.xenproject.org/xsa/xsa342.patch \
	https://xenbits.xenproject.org/xsa/xsa343/xsa343-1.patch \
	https://xenbits.xenproject.org/xsa/xsa343/xsa343-2.patch \
	https://xenbits.xenproject.org/xsa/xsa343/xsa343-3.patch \
	https://xenbits.xenproject.org/xsa/xsa344/xsa344-1.patch \
	https://xenbits.xenproject.org/xsa/xsa344/xsa344-2.patch

# xsa333.patch
XEN_IGNORE_CVES += CVE-2020-25602
# xsa334.patch
XEN_IGNORE_CVES += CVE-2020-25598
# xsa336.patch
XEN_IGNORE_CVES += CVE-2020-25604
# xsa337-1.patch, xsa337-2.patch
XEN_IGNORE_CVES += CVE-2020-25595
# xsa338.patch
XEN_IGNORE_CVES += CVE-2020-25597
# xsa339.patch
XEN_IGNORE_CVES += CVE-2020-25596
# xsa340.patch
XEN_IGNORE_CVES += CVE-2020-25603
# xsa342.patch
XEN_IGNORE_CVES += CVE-2020-25600
# xsa343-1.patch, xsa-343-2.patch, xsa-343-3.patch
XEN_IGNORE_CVES += CVE-2020-25599
# xsa344-1.patch, xsa344-2.patch
XEN_IGNORE_CVES += CVE-2020-25601

XEN_LICENSE = GPL-2.0
XEN_LICENSE_FILES = COPYING
XEN_DEPENDENCIES = host-acpica host-python3

# Calculate XEN_ARCH
ifeq ($(ARCH),aarch64)
XEN_ARCH = arm64
else ifeq ($(ARCH),arm)
XEN_ARCH = arm32
endif

XEN_CONF_OPTS = \
	--disable-golang \
	--disable-ocamltools \
	--with-initddir=/etc/init.d

XEN_CONF_ENV = PYTHON=$(HOST_DIR)/bin/python3
XEN_MAKE_ENV = \
	XEN_TARGET_ARCH=$(XEN_ARCH) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	HOST_EXTRACFLAGS="-Wno-error" \
	XEN_HAS_CHECKPOLICY=n \
	$(TARGET_CONFIGURE_OPTS)

ifeq ($(BR2_PACKAGE_XEN_HYPERVISOR),y)
XEN_MAKE_OPTS += dist-xen
XEN_INSTALL_IMAGES = YES
define XEN_INSTALL_IMAGES_CMDS
	cp $(@D)/xen/xen $(BINARIES_DIR)
endef
else
XEN_CONF_OPTS += --disable-xen
endif

ifeq ($(BR2_PACKAGE_XEN_TOOLS),y)
XEN_DEPENDENCIES += \
	dtc libaio libglib2 ncurses openssl pixman slirp util-linux yajl
ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
XEN_DEPENDENCIES += argp-standalone
endif
XEN_INSTALL_TARGET_OPTS += DESTDIR=$(TARGET_DIR) install-tools
XEN_MAKE_OPTS += dist-tools
XEN_CONF_OPTS += --with-extra-qemuu-configure-args="--disable-sdl --disable-opengl"

define XEN_INSTALL_INIT_SYSV
	mv $(TARGET_DIR)/etc/init.d/xencommons $(TARGET_DIR)/etc/init.d/S50xencommons
	mv $(TARGET_DIR)/etc/init.d/xen-watchdog $(TARGET_DIR)/etc/init.d/S50xen-watchdog
	mv $(TARGET_DIR)/etc/init.d/xendomains $(TARGET_DIR)/etc/init.d/S60xendomains
endef
else
XEN_INSTALL_TARGET = NO
XEN_CONF_OPTS += --disable-tools
endif

$(eval $(autotools-package))
