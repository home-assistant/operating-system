#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSIO_PATH}/scripts
BOARD_DIR=${2}
BOOT_DATA=${BINARIES_DIR}/boot

. ${SCRIPT_DIR}/hdd_image.sh
. ${BR2_EXTERNAL_HASSIO_PATH}/info
. ${BOARD_DIR}/info

# Filename
IMAGE_FILE=hassio-${BOARD_ID}_${VERSION_MAJOR}.${VERSION_BUILD}.vmdk

# Init boot data
rm -rf ${BOOT_DATA}
mkdir -p ${BOOT_DATA}/EFI/BOOT
mkdir -p ${BOOT_DATA}/EFI/barebox

cp ${BINARIES_DIR}/barebox.bin ${BOOT_DATA}/EFI/BOOT/BOOTx64.EFI
cp ${BOARD_DIR}/barebox-state.dtb ${BOOT_DATA}/EFI/barebox/state.dtb

# Create other layers
hassio_boot_image ${BINARIES_DIR}
hassio_overlay_image ${BINARIES_DIR}

hassio_hdd_image ${BINARIES_DIR} ${BINARIES_DIR}/harddisk.img 6

qemu-img convert -O vmdk ${BINARIES_DIR}/harddisk.img ${BINARIES_DIR}/${IMAGE_FILE}
