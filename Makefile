BUILDDIR:=$(shell pwd)

BUILDROOT=$(BUILDDIR)/buildroot
BUILDROOT_EXTERNAL=$(BUILDDIR)/buildroot-external
DEFCONFIG_DIR = $(BUILDROOT_EXTERNAL)/configs

TARGETS := $(notdir $(patsubst %_defconfig,%,$(wildcard $(DEFCONFIG_DIR)/*_defconfig)))
TARGETS_CONFIG := $(notdir $(patsubst %_defconfig,%-config,$(wildcard $(DEFCONFIG_DIR)/*_defconfig)))

# Set O variable if not already done on the command line
ifneq ("$(origin O)", "command line")
O := $(BUILDDIR)/output
else
override O := $(BUILDDIR)/$(O)
endif

.NOTPARALLEL: $(TARGETS) $(TARGETS_CONFIG) all

.PHONY: $(TARGETS) $(TARGETS_CONFIG) all clean help

all: $(TARGETS)

savedefconfig:
	@echo "config $*"
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL) "savedefconfig"

$(TARGETS_CONFIG): %-config:
	@echo "config $*"
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL) "$*_defconfig"

$(TARGETS): %: %-config
	@echo "build $@"
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL)

	# Do not clean when building for one target
ifneq ($(words $(filter $(TARGETS),$(MAKECMDGOALS))), 1)
	@echo "clean $@"
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL) clean
endif
	@echo "finished $@"

clean:
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL) clean

help:
	@echo "Supported targets: $(TARGETS)"
	@echo "Run 'make <target>' to build a target image."
	@echo "Run 'make all' to build all target images."
	@echo "Run 'make clean' to clean the build output."
	@echo "Run 'make <target>-config' to configure buildroot for a target."
