#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSOS_PATH}/scripts
BOARD_DIR=${2}
BOOT_DATA=${BINARIES_DIR}/boot

. ${BR2_EXTERNAL_HASSOS_PATH}/meta
. ${BOARD_DIR}/meta

. ${SCRIPT_DIR}/hdd-image.sh
. ${SCRIPT_DIR}/name.sh
. ${SCRIPT_DIR}/ota.sh

# Init boot data
rm -rf ${BOOT_DATA}
mkdir -p ${BOOT_DATA}/EFI/BOOT
mkdir -p ${BOOT_DATA}/EFI/barebox

cp ${BINARIES_DIR}/barebox.bin ${BOOT_DATA}/EFI/BOOT/BOOTx64.EFI
cp ${BR2_EXTERNAL_HASSOS_PATH}/misc/barebox-state-efi.dtb ${BOOT_DATA}/EFI/barebox/state.dtb

echo "console=tty1" > ${BOOT_DATA}/cmdline.txt

# Create disk images
create_disk_image

# Make VM
convert_disk_image_vmdk
convert_disk_image_gz vmdk

# OTA
create_ota_update
