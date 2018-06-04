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
    echo "disable_splash=1"
    echo "dtparam=audio=on"
    echo "enable_uart=1"
) > ${BOOT_DATA}/config.txt

echo "dwc_otg.lpm_enable=0 console=tty1 console=ttyAMA0,115200" > ${BOOT_DATA}/cmdline.txt

# Create other layers
create_boot_image ${BINARIES_DIR}
create_overlay_image ${BINARIES_DIR}

create_disk_image ${BINARIES_DIR} ${IMAGE_FILE} 2
fix_disk_image_mbr ${IMAGE_FILE}

rm -rf ${IMAGE_FILE}.gz
gzip --best ${IMAGE_FILE}
