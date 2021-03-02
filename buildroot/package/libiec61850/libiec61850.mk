################################################################################
#
# libiec61850
#
################################################################################

LIBIEC61850_VERSION = 1.4.2.1
LIBIEC61850_SITE = $(call github,mz-automation,libiec61850,v$(LIBIEC61850_VERSION))
LIBIEC61850_INSTALL_STAGING = YES
LIBIEC61850_LICENSE = GPL-3.0+
LIBIEC61850_LICENSE_FILES = COPYING
LIBIEC61850_CPE_ID_VENDOR = mz-automation
LIBIEC61850_CONF_OPTS = -DBUILD_PYTHON_BINDINGS=OFF

# 0003-COTP-fixed-possible-heap-buffer-overflow-when-handling-message.patch
LIBIEC61850_IGNORE_CVES += CVE-2020-15158

$(eval $(cmake-package))
