#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSOS_PATH}/scripts
BOARD_DIR=${2}
BOOT_DATA=${BINARIES_DIR}/boot

. ${SCRIPT_DIR}/hdd-image.sh
. ${BR2_EXTERNAL_HASSOS_PATH}/info
. ${BOARD_DIR}/info

# Filename
IMAGE_FILE=${BINARIES_DIR}/${HASSOS_ID}_${BOARD_ID}-${VERSION_MAJOR}.${VERSION_BUILD}.img

# Init boot data
rm -rf ${BOOT_DATA}
mkdir -p ${BOOT_DATA}

cp ${BINARIES_DIR}/barebox.bin ${BOOT_DATA}/
cp -t ${BOOT_DATA} \
    ${BINARIES_DIR}/bcm2709-rpi-2-b.dtb \
    ${BINARIES_DIR}/rpi-firmware/bootcode.bin \
    ${BINARIES_DIR}/rpi-firmware/fixup.dat \
    ${BINARIES_DIR}/rpi-firmware/start.elf
cp -r ${BINARIES_DIR}/rpi-firmware/overlays ${BOOT_DATA}/

# Update Boot options
(
    echo "kernel=barebox.bin"
    echo "cmdline=\"\""
    echo "gpu_mem=16"
    echo "disable_splash=1"
    echo "dtparam=i2c_arm=on"
    echo "dtparam=spi=on"
    echo "dtparam=audio=on"
) > ${BOOT_DATA}/config.txt


# Create other layers
create_boot_image ${BINARIES_DIR}
create_overlay_image ${BINARIES_DIR}

create_disk_image ${BINARIES_DIR} ${IMAGE_FILE} 2
fix_disk_image_mbr ${IMAGE_FILE}

rm -rf ${IMAGE_FILE}.gz
gzip ${IMAGE_FILE}
