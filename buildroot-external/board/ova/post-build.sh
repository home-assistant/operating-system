#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSIO_PATH}/scripts
BOARD_DIR="$(dirname $0)"

. ${SCRIPT_DIR}/rootfs_layer.sh

# HassioOS tasks
fix_rootfs

cp ${BOARD_DIR}/rauc.conf ${TARGET_DIR}/etc/rauc/system.conf
