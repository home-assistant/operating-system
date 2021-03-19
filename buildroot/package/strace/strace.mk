################################################################################
#
# strace
#
################################################################################

STRACE_VERSION = 5.10
STRACE_SOURCE = strace-$(STRACE_VERSION).tar.xz
STRACE_SITE = https://strace.io/files/$(STRACE_VERSION)
STRACE_LICENSE = LGPL-2.1+
STRACE_LICENSE_FILES = COPYING LGPL-2.1-or-later
STRACE_CPE_ID_VENDOR = strace_project
STRACE_CONF_OPTS = --enable-mpers=no

ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
STRACE_DEPENDENCIES += libunwind
STRACE_CONF_OPTS += --with-libunwind
else
STRACE_CONF_OPTS += --without-libunwind
endif

# Demangling symbols in stack trace needs libunwind and libiberty.
ifeq ($(BR2_PACKAGE_BINUTILS)$(BR2_PACKAGE_LIBUNWIND),yy)
STRACE_DEPENDENCIES += binutils
STRACE_CONF_OPTS += --with-libiberty=check
else
STRACE_CONF_OPTS += --without-libiberty
endif

ifeq ($(BR2_PACKAGE_PERL),)
define STRACE_REMOVE_STRACE_GRAPH
	rm -f $(TARGET_DIR)/usr/bin/strace-graph
endef

STRACE_POST_INSTALL_TARGET_HOOKS += STRACE_REMOVE_STRACE_GRAPH
endif

$(eval $(autotools-package))
