################################################################################
#
# qt5lottie
#
################################################################################

QT5LOTTIE_VERSION = $(QT5_VERSION)
QT5LOTTIE_SITE = $(QT5_SITE)
QT5LOTTIE_SOURCE = qtlottie-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5LOTTIE_VERSION).tar.xz
QT5LOTTIE_DEPENDENCIES = qt5declarative
QT5LOTTIE_INSTALL_STAGING = YES

QT5LOTTIE_LICENSE = GPL-3.0
QT5LOTTIE_LICENSE_FILES = LICENSE.GPL3 LICENSE.GPL3-EXCEPT

$(eval $(qmake-package))
