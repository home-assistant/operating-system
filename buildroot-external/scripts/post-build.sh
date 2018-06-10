#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSOS_PATH}/scripts
BOARD_DIR=${2}

. ${SCRIPT_DIR}/rootfs-layer.sh
. ${BR2_EXTERNAL_HASSOS_PATH}/info
. ${BOARD_DIR}/info

# HassOS tasks
fix_rootfs
install_hassos_cli

# Write os-release
(
    echo "NAME=${HASSOS_NAME}"
    echo "VERSION=\"${VERSION_MAJOR}.${VERSION_BUILD} (${BOARD_NAME})\""
    echo "ID=${HASSOS_ID}"
    echo "VERSION_ID=${VERSION_MAJOR}.${VERSION_BUILD}"
    echo "PRETTY_NAME=\"${HASSOS_NAME} ${VERSION_MAJOR}.${VERSION_BUILD}\""
    echo "CPE_NAME=cpe:2.3:o:home_assistant:${HASSOS_ID}:${VERSION_MAJOR}.${VERSION_BUILD}:*:${DEPLOYMENT}:*:*:*:${BOARD_ID}:*"
    echo "HOME_URL=https://hass.io/"
    echo "VARIANT=\"${HASSOS_NAME} ${BOARD_NAME}\""
    echo "VARIANT_ID=${BOARD_ID}"
) > ${TARGET_DIR}/usr/lib/os-release

# Write machine-info
(
    echo "CHASSIS=${CHASSIS}"
    echo "DEPLOYMENT=${DEPLOYMENT}"
) > ${TARGET_DIR}/etc/machine-info

# Settup rauc
sed -i "s/%COMPATIBLE%/${HASSOS_ID}-${BOARD_ID}/g" ${TARGET_DIR}/etc/rauc/system.conf
sed -i "s/%BOOTLOADER%/${BOOTLOADER}/g" ${TARGET_DIR}/etc/rauc/system.conf

# Settup the correct CA
if [ "${DEPLOYMENT}" == "development" ]; then
    cp ${BR2_EXTERNAL_HASSOS_PATH}/misc/provisioning-ca.pem ${TARGET_DIR}/etc/rauc/keyring.pem
else
    cp ${BR2_EXTERNAL_HASSOS_PATH}/misc/rel-ca.pem ${TARGET_DIR}/etc/rauc/keyring.pem
fi
