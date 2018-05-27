#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSOS_PATH}/scripts
BOARD_DIR=${2}
BOOT_DATA=${BINARIES_DIR}/boot

. ${SCRIPT_DIR}/hdd-image.sh
. ${BR2_EXTERNAL_HASSOS_PATH}/info
. ${BOARD_DIR}/info

# Filename
IMAGE_FILE=${HASSOS_ID}_${BOARD_ID}-${VERSION_MAJOR}.${VERSION_BUILD}.vmdk

# Init boot data
rm -rf ${BOOT_DATA}
mkdir -p ${BOOT_DATA}/EFI/BOOT
mkdir -p ${BOOT_DATA}/EFI/barebox

cp ${BINARIES_DIR}/barebox.bin ${BOOT_DATA}/EFI/BOOT/BOOTx64.EFI
cp ${BR2_EXTERNAL_HASSOS_PATH}/fdt/barebox-state-efi.dtb ${BOOT_DATA}/EFI/barebox/state.dtb

# Create other layers
create_boot_image ${BINARIES_DIR}
create_overlay_image ${BINARIES_DIR}

create_disk_image ${BINARIES_DIR} ${BINARIES_DIR}/harddisk.img 6

qemu-img convert -O vmdk ${BINARIES_DIR}/harddisk.img ${BINARIES_DIR}/${IMAGE_FILE}
