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

################################################################################

COLOR_STEP := $(shell tput smso 2>/dev/null)
COLOR_WARN := $(shell (tput setab 3; tput setaf 0) 2>/dev/null)
TERM_RESET := $(shell tput sgr0 2>/dev/null)

################################################################################

.NOTPARALLEL: $(TARGETS) $(TARGETS_CONFIG) default

.PHONY: $(TARGETS) $(TARGETS_CONFIG) default buildroot-help help

# fallback target when target undefined here is given
.DEFAULT:
	@echo "$(COLOR_STEP)=== Falling back to Buildroot target '$@' ===$(TERM_RESET)"
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL) "$@"

# default target when no target is given - must be first in Makefile
default:
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL)

$(TARGETS_CONFIG): %-config:
	@if [ -f $(O)/.config ] && ! grep -q 'BR2_DEFCONFIG="$(DEFCONFIG_DIR)/$*_defconfig"' $(O)/.config; then \
		echo "$(COLOR_WARN)WARNING: Output directory '$(O)' already contains files for another target!$(TERM_RESET)"; \
		echo "         Before running build for a different target, run 'make distclean' first."; \
		echo ""; \
		bash -c 'read -t 10 -p "Waiting 10s, press enter to continue or Ctrl-C to abort..."' || true; \
	fi
	@echo "$(COLOR_STEP)=== Using $*_defconfig ===$(TERM_RESET)"
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL) "$*_defconfig"

$(TARGETS): %: %-config
	@echo "$(COLOR_STEP)=== Building $@ ===$(TERM_RESET)"
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL)

buildroot-help:
	$(MAKE) -C $(BUILDROOT) O=$(O) BR2_EXTERNAL=$(BUILDROOT_EXTERNAL) help

help:
	@echo "Run 'make <target>' to build a target image."
	@echo "Run 'make <target>-config' to configure buildroot for a target."
	@echo ""
	@echo "Supported targets: $(TARGETS)"
	@echo ""
	@echo "Unknown Makefile targets fall back to Buildroot make - for details run 'make buildroot-help'"
