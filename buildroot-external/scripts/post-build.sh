#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSIO_PATH}/scripts
BOARD_DIR=${2}

. ${SCRIPT_DIR}/rootfs_layer.sh
. ${BR2_EXTERNAL_HASSIO_PATH}/info
. ${BOARD_DIR}/info

# Hass.io OS tasks
fix_rootfs
install_hassio_cli

# Write os-release
(
    echo "NAME=Hass.io"
    echo "VERSION=\"${VERSION_MAJOR}.${VERSION_BUILD} (${BOARD_NAME})\""
    echo "ID=hassio-os"
    echo "VERSION_ID=${VERSION_MAJOR}.${VERSION_BUILD}"
    echo "PRETTY_NAME=\"${HASSIO_NAME} ${VERSION_MAJOR}.${VERSION_BUILD}\""
    echo "CPE_NAME=cpe:2.3:o:home_assistant:hassio:${VERSION_MAJOR}.${VERSION_BUILD}:*:${DEPLOYMENT}:*:*:*:${BOARD_ID}:*"
    echo "HOME_URL=https://hass.io/"
    echo "VARIANT=\"Hass.io ${BOARD_NAME}\""
    echo "VARIANT_ID=${BOARD_ID}"
) > /etc/os-release

# Write machine-info
(
    echo "CHASSIS=${CHASSIS}"
    echo "DEPLOYMENT=${DEPLOYMENT}"
) > /etc/machine-info
