################################################################################
#
# tpm2-tss
#
################################################################################

TPM2_TSS_VERSION = 3.0.3
TPM2_TSS_SITE = https://github.com/tpm2-software/tpm2-tss/releases/download/$(TPM2_TSS_VERSION)
TPM2_TSS_LICENSE = BSD-2-Clause
TPM2_TSS_LICENSE_FILES = LICENSE
TPM2_TSS_INSTALL_STAGING = YES
TPM2_TSS_DEPENDENCIES = liburiparser openssl host-pkgconf
TPM2_TSS_CONF_OPTS = --with-crypto=ossl --disable-doxygen-doc --disable-defaultflags
# 0001-configure-Only-use-CXX-when-fuzzing.patch
TPM2_TSS_AUTORECONF = YES

# uses C99 code but forgets to pass -std=c99 when --disable-defaultflags is used
TPM2_TSS_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=c99"

ifeq ($(BR2_PACKAGE_TPM2_TSS_FAPI),y)
TPM2_TSS_DEPENDENCIES += json-c libcurl
TPM2_TSS_CONF_OPTS += --enable-fapi
else
TPM2_TSS_CONF_OPTS += --disable-fapi
endif

$(eval $(autotools-package))
