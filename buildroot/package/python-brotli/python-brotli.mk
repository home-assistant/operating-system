################################################################################
#
# python-brotli
#
################################################################################

PYTHON_BROTLI_VERSION = 1.0.9
PYTHON_BROTLI_SOURCE = Brotli-$(PYTHON_BROTLI_VERSION).zip
PYTHON_BROTLI_SITE = https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0
PYTHON_BROTLI_SETUP_TYPE = setuptools
PYTHON_BROTLI_LICENSE = MIT
PYTHON_BROTLI_LICENSE_FILES = LICENSE

PYTHON_BROTLI_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
PYTHON_BROTLI_CFLAGS += -O0
endif

PYTHON_BROTLI_ENV = CFLAGS="$(PYTHON_BROTLI_CFLAGS)"

define PYTHON_BROTLI_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(PYTHON_BROTLI_DL_DIR)/$(PYTHON_BROTLI_SOURCE)
	mv $(@D)/Brotli-$(PYTHON_BROTLI_VERSION)/* $(@D)
	$(RM) -r $(@D)/Brotli-$(PYTHON_BROTLI_VERSION)
endef

$(eval $(python-package))
