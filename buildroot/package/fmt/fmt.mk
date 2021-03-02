################################################################################
#
# fmt
#
################################################################################

FMT_VERSION = 7.1.3
FMT_SITE = https://github.com/fmtlib/fmt/releases/download/$(FMT_VERSION)
FMT_SOURCE = fmt-$(FMT_VERSION).zip
FMT_LICENSE = MIT with exception
FMT_LICENSE_FILES = LICENSE.rst
FMT_INSTALL_STAGING = YES

FMT_CONF_OPTS = \
	-DFMT_INSTALL=ON \
	-DFMT_TEST=OFF

define FMT_EXTRACT_CMDS
	$(UNZIP) -d $(BUILD_DIR) $(FMT_DL_DIR)/$(FMT_SOURCE)
endef

$(eval $(cmake-package))
