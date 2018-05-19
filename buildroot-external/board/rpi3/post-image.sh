#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSOS_PATH}/scripts
BOARD_DIR=${2}
BOOT_DATA=${BINARIES_DIR}/boot

. ${SCRIPT_DIR}/hdd-image.sh
. ${BR2_EXTERNAL_HASSOS_PATH}/info
. ${BOARD_DIR}/info

# Filename
IMAGE_FILE=${HASSOS_ID}_${BOARD_ID}-${VERSION_MAJOR}.${VERSION_BUILD}.img

# Init boot data
rm -rf ${BOOT_DATA}
mkdir -p ${BOOT_DATA}

cp ${BINARIES_DIR}/barebox.bin ${BOOT_DATA}/
cp -t ${BOOT_DATA} bcm2710-rpi-3-b.dtb bcm2710-rpi-3-b-plus.dtb bcm2710-rpi-cm3.dtb 
cp -t ${BOOT_DATA} rpi-firmware/bootcode.bin rpi-firmware/config.txt rpi-firmware/fixup.dat rpi-firmware/start.elf
cp -r rpi-firmware/overlays ${BOOT_DATA}/

# Update Boot options


# Create other layers
create_boot_image ${BINARIES_DIR}
create_overlay_image ${BINARIES_DIR}

create_disk_image ${BINARIES_DIR} ${BINARIES_DIR}/${IMAGE_FILE} 6
fix_disk_image_mbr ${BINARIES_DIR}/${IMAGE_FILE}

bzip2 ${BINARIES_DIR}/${IMAGE_FILE}
