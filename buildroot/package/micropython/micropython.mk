################################################################################
#
# micropython
#
################################################################################

MICROPYTHON_VERSION = 1.13
MICROPYTHON_SITE = $(call github,micropython,micropython,v$(MICROPYTHON_VERSION))
MICROPYTHON_LICENSE = MIT
MICROPYTHON_LICENSE_FILES = LICENSE
MICROPYTHON_DEPENDENCIES = host-pkgconf libffi $(BR2_PYTHON3_HOST_DEPENDENCY)

# Set GIT_DIR so package won't use buildroot's version number
MICROPYTHON_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	GIT_DIR=.

# Use fallback implementation for exception handling on architectures that don't
# have explicit support.
ifeq ($(BR2_i386)$(BR2_x86_64)$(BR2_arm)$(BR2_armeb),)
MICROPYTHON_CFLAGS = -DMICROPY_GCREGS_SETJMP=1
endif

# xtensa has problems with nlr_push, use setjmp based implementation instead
ifeq ($(BR2_xtensa),y)
MICROPYTHON_CFLAGS = -DMICROPY_NLR_SETJMP=1
endif

# When building from a tarball we don't have some of the dependencies that are in
# the git repository as submodules
MICROPYTHON_MAKE_OPTS += \
	MICROPY_PY_BTREE=0 \
	MICROPY_PY_USSL=0 \
	CROSS_COMPILE=$(TARGET_CROSS) \
	CFLAGS_EXTRA=$(MICROPYTHON_CFLAGS) \
	CWARN=

define MICROPYTHON_BUILD_CMDS
	$(MICROPYTHON_MAKE_ENV) $(MAKE) -C $(@D)/mpy-cross
	$(MICROPYTHON_MAKE_ENV) $(MAKE) -C $(@D)/ports/unix \
		$(MICROPYTHON_MAKE_OPTS)
endef

define MICROPYTHON_INSTALL_TARGET_CMDS
	$(MICROPYTHON_MAKE_ENV) $(MAKE) -C $(@D)/ports/unix \
		$(MICROPYTHON_MAKE_OPTS) \
		DESTDIR=$(TARGET_DIR) \
		PREFIX=/usr \
		install
endef

$(eval $(generic-package))
