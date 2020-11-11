################################################################################
#
# ltrace
#
################################################################################

# This github version has some extra fixes on top of https://ltrace.org/
# in particular the following commit to avoid a crash:
#   192e0a6 void struct members are now ignored
LTRACE_VERSION = 82c66409c7a93ca6ad2e4563ef030dfb7e6df4d4
LTRACE_SITE = $(call github,dkogan,ltrace,$(LTRACE_VERSION))
LTRACE_DEPENDENCIES = elfutils
LTRACE_CONF_OPTS = --disable-werror
LTRACE_LICENSE = GPL-2.0
LTRACE_LICENSE_FILES = COPYING
LTRACE_AUTORECONF = YES

# ltrace can use libunwind only if libc has backtrace() support
# We don't normally do so for uClibc and we can't know if it's external
# Also ltrace with libunwind support is broken for MIPS so we disable it
ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC)$(BR2_mips)$(BR2_mipsel),)
# --with-elfutils only selects unwinding support backend. elfutils is a
# mandatory dependency regardless.
LTRACE_CONF_OPTS += --with-libunwind=yes --with-elfutils=no
LTRACE_DEPENDENCIES += libunwind
else
LTRACE_CONF_OPTS += --with-libunwind=no
endif
endif

$(eval $(autotools-package))
