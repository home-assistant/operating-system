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
mkdir -p ${BOOT_DATA}

cp ${BINARIES_DIR}/boot.scr ${BOOT_DATA}/boot.scr
cp ${BOARD_DIR}/boot-env.txt ${BOOT_DATA}/uboot-settings.txt
cp ${BINARIES_DIR}/meson-gxbb-odroidc2.dtb ${BOOT_DATA}/meson-gxbb-odroidc2.dtb

echo "console=tty0 console=ttyAML0,115200n8" > ${BOOT_DATA}/cmdline.txt

function make_bootable() {
    local BL1="${BINARIES_DIR}/bl1.bin.hardkernel"
    local UBOOT_GXBB="${BINARIES_DIR}/u-boot.gxbb"
    local hdd_img="$(hassos_image_name img)"

    dd if=${BL1} of=${hdd_img} conv=notrunc bs=1 count=442
    dd if=${BL1} of=${hdd_img} conv=notrunc bs=512 skip=1 seek=1
    dd if=${UBOOT_GXBB} of=${hdd_img} conv=notrunc bs=512 seek=97
}

# Create other layers
prepare_disk_image

create_disk_mbr 2
make_bootable
convert_disk_image_gz
create_ota_update
