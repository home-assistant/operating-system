#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSOS_PATH}/scripts
BOARD_DIR=${2}
BOOT_DATA=${BINARIES_DIR}/boot

. ${SCRIPT_DIR}/hdd-image.sh
. ${SCRIPT_DIR}/name.sh
. ${SCRIPT_DIR}/ota.sh
. ${BR2_EXTERNAL_HASSOS_PATH}/info
. ${BOARD_DIR}/info

# Init boot data
rm -rf ${BOOT_DATA}
mkdir -p ${BOOT_DATA}

cp -t ${BOOT_DATA} \
    ${BINARIES_DIR}/boot.scr \
    ${BINARIES_DIR}/rk3288-tinker.dtb

echo "console=tty1" > ${BOOT_DATA}/cmdline.txt

# Create boot binary
rm -f $BINARIES_DIR/u-boot-spl-dtb.img
mkimage -n rk3288 -T rksd -d $BINARIES_DIR/u-boot-spl-dtb.bin $BINARIES_DIR/u-boot-spl-dtb.img
cat $BINARIES_DIR/u-boot-dtb.bin >> $BINARIES_DIR/u-boot-spl-dtb.img

# Create other layers
prepare_disk_image
create_spl_image u-boot-spl-dtb.img 64

create_disk_image 2
convert_disk_image_gz
create_ota_update
