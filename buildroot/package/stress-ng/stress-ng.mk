################################################################################
#
# stress-ng
#
################################################################################

STRESS_NG_VERSION = 0.11.17
STRESS_NG_SOURCE = stress-ng-$(STRESS_NG_VERSION).tar.xz
STRESS_NG_SITE = http://kernel.ubuntu.com/~cking/tarballs/stress-ng
STRESS_NG_LICENSE = GPL-2.0+
STRESS_NG_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBBSD):$(BR2_STATIC_LIBS),y:)
STRESS_NG_DEPENDENCIES += libbsd
else
STRESS_NG_MAKE_OPTS += HAVE_LIB_BSD=0 HAVE_WCSLCAT=0 \
	HAVE_WCSLCPY=0 HAVE_SETPROCTITLE=0
endif

ifeq ($(BR2_PACKAGE_KEYUTILS),y)
STRESS_NG_DEPENDENCIES += keyutils
endif

define STRESS_NG_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(STRESS_NG_MAKE_OPTS) -C $(@D)
endef

# Don't use make install otherwise stress-ng will be rebuild without
# required link libraries if any. Furthermore, using INSTALL allow to
# set the file permission correcly on the target.
define STRESS_NG_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/stress-ng $(TARGET_DIR)/usr/bin/stress-ng
endef

$(eval $(generic-package))
