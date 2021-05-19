################################################################################
#
# sysstat
#
################################################################################

SYSSTAT_VERSION = 12.4.2
SYSSTAT_SOURCE = sysstat-$(SYSSTAT_VERSION).tar.xz
SYSSTAT_SITE = http://pagesperso-orange.fr/sebastien.godard
SYSSTAT_CONF_OPTS = --disable-file-attr
SYSSTAT_DEPENDENCIES = host-gettext $(TARGET_NLS_DEPENDENCIES)
SYSSTAT_LICENSE = GPL-2.0+
SYSSTAT_LICENSE_FILES = COPYING
SYSSTAT_CPE_ID_VENDOR = sysstat_project

ifeq ($(BR2_PACKAGE_LM_SENSORS),y)
SYSSTAT_DEPENDENCIES += lm-sensors
SYSSTAT_CONF_OPTS += --enable-sensors
else
SYSSTAT_CONF_OPTS += --disable-sensors
endif

$(eval $(autotools-package))
