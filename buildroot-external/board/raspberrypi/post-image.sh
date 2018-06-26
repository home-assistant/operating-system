#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSOS_PATH}/scripts
BOARD_DIR=${2}
BOOT_DATA=${BINARIES_DIR}/boot

. ${SCRIPT_DIR}/hdd-image.sh
. ${SCRIPT_DIR}/name.sh
. ${BR2_EXTERNAL_HASSOS_PATH}/info
. ${BOARD_DIR}/info

# Init boot data
rm -rf ${BOOT_DATA}
mkdir -p ${BOOT_DATA}

cp -t ${BOOT_DATA} \
    ${BINARIES_DIR}/u-boot.bin \
    ${BINARIES_DIR}/boot.scr
cp -t ${BOOT_DATA} \
    ${BINARIES_DIR}/*.dtb \
    ${BINARIES_DIR}/rpi-firmware/bootcode.bin \
    ${BINARIES_DIR}/rpi-firmware/fixup.dat \
    ${BINARIES_DIR}/rpi-firmware/start.elf
cp -r ${BINARIES_DIR}/rpi-firmware/overlays ${BOOT_DATA}/

# Update Boot options
(
    echo "kernel=u-boot.bin"
    echo "disable_splash=1"
    echo "dtparam=audio=on"
) > ${BOOT_DATA}/config.txt

echo "dwc_otg.lpm_enable=0 console=tty1" > ${BOOT_DATA}/cmdline.txt

# Enable 64bit support
if [ "${BOARD_ID}" == "rpi3-64" ]; then
    echo "arm_64bit=1" >> ${BOOT_DATA}/config.txt
fi

# Create other layers
prepare_disk_image

create_disk_image 2
fix_disk_image_mbr
convert_disk_image_gz
create_ota_update
