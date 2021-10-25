################################################################################
#
# refpolicy
#
################################################################################

REFPOLICY_LICENSE = GPL-2.0
REFPOLICY_LICENSE_FILES = COPYING
REFPOLICY_CPE_ID_VENDOR = selinuxproject
REFPOLICY_INSTALL_STAGING = YES
REFPOLICY_DEPENDENCIES = \
	host-m4 \
	host-checkpolicy \
	host-policycoreutils \
	host-python3 \
	host-setools \
	host-gawk \
	host-libxml2

ifeq ($(BR2_PACKAGE_REFPOLICY_CUSTOM_GIT),y)
REFPOLICY_VERSION = $(call qstrip,$(BR2_PACKAGE_REFPOLICY_CUSTOM_REPO_VERSION))
REFPOLICY_SITE = $(call qstrip,$(BR2_PACKAGE_REFPOLICY_CUSTOM_REPO_URL))
REFPOLICY_SITE_METHOD = git
BR_NO_CHECK_HASH_FOR += $(REFPOLICY_SOURCE)
else
REFPOLICY_VERSION = 2.20200818
REFPOLICY_SOURCE = refpolicy-$(REFPOLICY_VERSION).tar.bz2
REFPOLICY_SITE = https://github.com/SELinuxProject/refpolicy/releases/download/RELEASE_2_20200818
endif

# Cannot use multiple threads to build the reference policy
REFPOLICY_MAKE = \
	PYTHON=$(HOST_DIR)/usr/bin/python3 \
	XMLLINT=$(LIBXML2_HOST_BINARY) \
	TEST_TOOLCHAIN=$(HOST_DIR) \
	$(TARGET_MAKE_ENV) \
	$(MAKE1)

REFPOLICY_POLICY_VERSION = $(BR2_PACKAGE_LIBSEPOL_POLICY_VERSION)
REFPOLICY_POLICY_STATE = \
	$(call qstrip,$(BR2_PACKAGE_REFPOLICY_POLICY_STATE))

ifeq ($(BR2_PACKAGE_REFPOLICY_UPSTREAM_VERSION),y)

# Allow to provide out-of-tree SELinux modules in addition to the ones
# in the refpolicy.
REFPOLICY_EXTRA_MODULES_DIRS = \
	$(strip \
		$(call qstrip,$(BR2_REFPOLICY_EXTRA_MODULES_DIRS)) \
		$(PACKAGES_SELINUX_EXTRA_MODULES_DIRS))
$(foreach dir,$(REFPOLICY_EXTRA_MODULES_DIRS),\
	$(if $(wildcard $(dir)),,\
		$(error BR2_REFPOLICY_EXTRA_MODULES_DIRS contains nonexistent directory $(dir))))

REFPOLICY_MODULES = \
	application \
	authlogin \
	getty \
	init \
	libraries \
	locallogin \
	logging \
	miscfiles \
	modutils \
	mount \
	selinuxutil \
	storage \
	sysadm \
	sysnetwork \
	unconfined \
	userdomain \
	$(PACKAGES_SELINUX_MODULES) \
	$(call qstrip,$(BR2_REFPOLICY_EXTRA_MODULES)) \
	$(foreach d,$(REFPOLICY_EXTRA_MODULES_DIRS),\
		$(basename $(notdir $(wildcard $(d)/*.te))))

define REFPOLICY_COPY_EXTRA_MODULES
	mkdir -p $(@D)/policy/modules/buildroot
	rsync -au $(addsuffix /*,$(REFPOLICY_EXTRA_MODULES_DIRS)) \
		$(@D)/policy/modules/buildroot/
	if [ ! -f $(@D)/policy/modules/buildroot/metadata.xml ]; then \
		echo "<summary>Buildroot extra modules</summary>" > \
			$(@D)/policy/modules/buildroot/metadata.xml; \
	fi
endef

# In the context of a monolithic policy enabling a piece of the policy as
# 'base' or 'module' is equivalent, so we enable them as 'base'.
define REFPOLICY_CONFIGURE_MODULES
	$(SED) "s/ = module/ = no/g" $(@D)/policy/modules.conf
	$(foreach m,$(sort $(REFPOLICY_MODULES)),
		$(SED) "/^$(m) =/c\$(m) = base" $(@D)/policy/modules.conf
	)
endef

endif # BR2_PACKAGE_REFPOLICY_UPSTREAM_VERSION = y

ifeq ($(BR2_INIT_SYSTEMD),y)
define REFPOLICY_CONFIGURE_SYSTEMD
	$(SED) "/SYSTEMD/c\SYSTEMD = y" $(@D)/build.conf
endef
endif

define REFPOLICY_CONFIGURE_CMDS
	$(SED) "/OUTPUT_POLICY/c\OUTPUT_POLICY = $(REFPOLICY_POLICY_VERSION)" \
		$(@D)/build.conf
	$(SED) "/MONOLITHIC/c\MONOLITHIC = y" $(@D)/build.conf
	$(SED) "/NAME/c\NAME = targeted" $(@D)/build.conf
	$(REFPOLICY_CONFIGURE_SYSTEMD)
	$(if $(REFPOLICY_EXTRA_MODULES_DIRS), \
		$(REFPOLICY_COPY_EXTRA_MODULES)
	)
	$(REFPOLICY_MAKE) -C $(@D) bare conf
	$(REFPOLICY_CONFIGURE_MODULES)
endef

define REFPOLICY_BUILD_CMDS
	$(REFPOLICY_MAKE) -C $(@D) policy
endef

define REFPOLICY_INSTALL_STAGING_CMDS
	$(REFPOLICY_MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) \
		install-src install-headers
endef

define REFPOLICY_INSTALL_TARGET_CMDS
	$(REFPOLICY_MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	$(INSTALL) -m 0755 -D package/refpolicy/config \
		$(TARGET_DIR)/etc/selinux/config
	$(SED) "/^SELINUX=/c\SELINUX=$(REFPOLICY_POLICY_STATE)" \
		$(TARGET_DIR)/etc/selinux/config
endef

$(eval $(generic-package))
