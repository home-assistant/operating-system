################################################################################
#
# CoreMark-PRO
#
################################################################################

COREMARK_PRO_VERSION = 1.1.2743
COREMARK_PRO_SITE = $(call github,eembc,coremark-pro,v$(COREMARK_PRO_VERSION))
COREMARK_PRO_LICENSE = Apache-2.0
COREMARK_PRO_LICENSE_FILES = LICENSE.md
COREMARK_PRO_DEPENDENCIES = perl

COREMARK_PRO_LDFLAGS = $(TARGET_LDFLAGS) -lm

ifeq ($(BR2_ENDIAN),"BIG")
COREMARK_PRO_DEFINES += \
	EE_BIG_ENDIAN=1 \
	EE_LITTLE_ENDIAN=0
else
COREMARK_PRO_DEFINES += \
	EE_BIG_ENDIAN=0 \
	EE_LITTLE_ENDIAN=1
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
COREMARK_PRO_DEFINES += \
	USE_NATIVE_PTHREAD=1 \
	USE_SINGLE_CONTEXT=0
COREMARK_PRO_LDFLAGS += -lpthread
else
COREMARK_PRO_DEFINES += \
	USE_NATIVE_PTHREAD=0 \
	USE_SINGLE_CONTEXT=1
endif

COREMARK_PRO_MAKE_OPTS += \
	LINKER_LAST="$(COREMARK_PRO_LDFLAGS)" \
	PLATFORM_DEFINES="$(COREMARK_PRO_DEFINES)" \
	TARGET=linux$(if $(BR2_ARCH_IS_64),64) \
	EXE=

define COREMARK_PRO_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC)" LD="$(TARGET_CC)" -C $(@D) \
		$(COREMARK_PRO_MAKE_OPTS) build
endef

COREMARK_PRO_MARKS = cjpeg-rose7-preset core linear_alg-mid-100x100-sp loops-all-mid-10k-sp nnet_test parser-125k radix2-big-64k sha-test zip-test
COREMARK_PRO_SCRIPTS = results_parser.pl cert_median.pl cert_mark.pl headings.txt

define COREMARK_PRO_INSTALL_TARGET_CMDS
	mkdir -p  $(TARGET_DIR)/usr/share/coremark-pro/logs
	$(foreach m,$(COREMARK_PRO_MARKS),\
		$(INSTALL) -D $(@D)/builds/linux$(if $(BR2_ARCH_IS_64),64)/gcc$(if $(BR2_ARCH_IS_64),64)/bin/$(m) $(TARGET_DIR)/usr/bin/$(m)$(sep) \
		size $(TARGET_DIR)/usr/bin/$(m) > $(TARGET_DIR)/usr/share/coremark-pro/logs/$(m).size.log$(sep))
	$(INSTALL) -D $(@D)/builds/linux$(if $(BR2_ARCH_IS_64),64)/gcc$(if $(BR2_ARCH_IS_64),64)/data/libbmp/Rose256.bmp $(TARGET_DIR)/usr/share/coremark-pro/Rose256.bmp
	$(foreach s,$(COREMARK_PRO_SCRIPTS),\
		$(INSTALL) -D $(@D)/util/perl/$(s) $(TARGET_DIR)/usr/share/coremark-pro/util/perl/$(s)$(sep))
	$(Q)sed "s/@COREMARK_PRO_MARKS@/$(COREMARK_PRO_MARKS)/" \
		package/coremark-pro/coremark-pro.sh.in >$(TARGET_DIR)/usr/bin/coremark-pro.sh
endef

$(eval $(generic-package))
