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

# Filename
IMAGE_HDD=$(hassos_image_name img)
IMAGE_VMDK=$(hassos_image_name vmdk)

# Init boot data
rm -rf ${BOOT_DATA}
mkdir -p ${BOOT_DATA}/EFI/BOOT
mkdir -p ${BOOT_DATA}/EFI/barebox

cp ${BINARIES_DIR}/barebox.bin ${BOOT_DATA}/EFI/BOOT/BOOTx64.EFI
cp ${BR2_EXTERNAL_HASSOS_PATH}/misc/barebox-state-efi.dtb ${BOOT_DATA}/EFI/barebox/state.dtb

echo "console=tty1" > ${BOOT_DATA}/cmdline.txt

# Create other layers
create_boot_image
create_overlay_image
create_kernel_image bzImage

create_disk_image 6
qemu-img convert -O vmdk ${IMAGE_HDD} ${IMAGE_VMDK}

# Generate OTA update file
create_ota_update bzImage
