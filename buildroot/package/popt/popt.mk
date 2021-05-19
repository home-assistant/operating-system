################################################################################
#
# popt
#
################################################################################

POPT_VERSION = 1.18
POPT_SITE = http://ftp.rpm.org/popt/releases/popt-1.x
POPT_INSTALL_STAGING = YES
POPT_LICENSE = MIT
POPT_LICENSE_FILES = COPYING
POPT_CPE_ID_VENDOR = popt_project

POPT_GETTEXTIZE = YES
POPT_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)
# We're patching configure.ac
POPT_AUTORECONF = YES

POPT_CONF_ENV = ac_cv_va_copy=yes

ifeq ($(BR2_PACKAGE_LIBICONV),y)
POPT_CONF_ENV += am_cv_lib_iconv=yes
POPT_CONF_OPTS += --with-libiconv-prefix=$(STAGING_DIR)/usr
POPT_DEPENDENCIES += libiconv
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
