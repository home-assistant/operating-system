################################################################################
#
# qt5quicktimeline
#
################################################################################

QT5QUICKTIMELINE_VERSION = $(QT5_VERSION)
QT5QUICKTIMELINE_SITE = $(QT5_SITE)
QT5QUICKTIMELINE_SOURCE = qtquicktimeline-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5QUICKTIMELINE_VERSION).tar.xz
QT5QUICKTIMELINE_DEPENDENCIES = qt5declarative
QT5QUICKTIMELINE_INSTALL_STAGING = YES

QT5QUICKTIMELINE_LICENSE = GPL-3.0, GFDL-1.3 (docs)
QT5QUICKTIMELINE_LICENSE_FILES = LICENSE.GPL3

$(eval $(qmake-package))
