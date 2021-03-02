################################################################################
#
# qt5mqtt
#
################################################################################

QT5MQTT_VERSION = $(QT5_VERSION)
QT5MQTT_SITE = https://code.qt.io/cgit/qt/qtmqtt.git
QT5MQTT_SITE_METHOD = git
QT5MQTT_INSTALL_STAGING = YES
QT5MQTT_LICENSE = GPL-3.0 with exception
QT5MQTT_LICENSE_FILES = LICENSE.GPL3 LICENSE.GPL3-EXCEPT
QT5MQTT_SYNC_QT_HEADERS = YES

$(eval $(qmake-package))
