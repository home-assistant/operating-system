################################################################################
#
# qt5remoteobjects
#
################################################################################

QT5REMOTEOBJECTS_VERSION = $(QT5_VERSION)
QT5REMOTEOBJECTS_SITE = $(QT5_SITE)
QT5REMOTEOBJECTS_SOURCE = qtremoteobjects-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5REMOTEOBJECTS_VERSION).tar.xz
QT5REMOTEOBJECTS_DEPENDENCIES = qt5base
QT5REMOTEOBJECTS_INSTALL_STAGING = YES
QT5REMOTEOBJECTS_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception (tools), GFDL-1.3 (docs)
QT5REMOTEOBJECTS_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT LICENSE.LGPL3

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5REMOTEOBJECTS_DEPENDENCIES += qt5declarative
endif

$(eval $(qmake-package))
