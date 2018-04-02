#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSIO_PATH}/scripts
BOARD_DIR="$(dirname $0)"

OVERLAY_IMG=${BINARIES_DIR}/overlay.ext4
DATA_IMG=${BINARIES_DIR}/data.ext4
BOOT_IMG=${BINARIES_DIR}/boot.vfat

BOOT_DATA=${BINARIES_DIR}/boot-data

. ${SCRIPT_DIR}/hdd_image.sh

rm -rf ${BOOT_DATA}

# Init boot data
mkdir -p ${BOOT_DATA}/EFI/BOOT
mkdir -p ${BOOT_DATA}/EFI/barebox

cp ${BINARIES_DIR}/barebox.bin ${BOOT_DATA}/EFI/BOOT/BOOTx64.EFI
cp ${BOARD_DIR}/barebox-state.dtb ${BOOT_DATA}/EFI/barebox/state.dtb

hassio_boot_image ${BOOT_DATA} ${BOOT_IMG}
hassio_overlay_image ${OVERLAY_IMG}
hassio_data_image ${DATA_IMG}


hassio_hdd_image ${BOOT_IMG} ${BINARIES_DIR}/rootfs.squashfs ${OVERLAY_IMG} ${DATA_IMG} ${BINARIES_DIR}/harddisk.img

qemu-img convert -O vmdk ${BINARIES_DIR}/harddisk.img ${BINARIES_DIR}/hassio-os.vmdk
