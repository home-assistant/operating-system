#!/bin/bash

BOOT_SIZE=32M
BOOTSTATE_UUID="33236519-7F32-4DFF-8002-3390B62C309D"
BOOTSTATE_SIZE=8M
SYSTEM_SIZE=256M
OVERLAY_SIZE=64M
DATA_SIZE=1G
IMAGE_SIZE=2G

function hassio_boot_image() {
    local boot_data="${1}/boot"
    local boot_img="${1}/boot.vfat"

    echo "mtools_skip_check=1" > ~/.mtoolsrc
    dd if=/dev/zero of=${boot_img} bs=${BOOT_SIZE} count=1
    mkfs.vfat -n "hassio-boot" ${boot_img}
    mcopy -i ${boot_img} -sv ${boot_data}/* ::
}

function hassio_overlay_image() {
    local overlay_img="${1}/overlay.ext4"

    dd if=/dev/zero of=${overlay_img} bs=${OVERLAY_SIZE} count=1
    mkfs.ext4 -L "hassio-overlay" -E lazy_itable_init=0,lazy_journal_init=0 ${overlay_img}
}

function hassio_hdd_image() {
    local boot_img="${1}/boot.vfat"
    local rootfs_img="${1}/rootfs.squashfs"
    local overlay_img="${1}/overlay.ext4"
    local data_img="${1}/data.ext4"
    local hdd_img="${2}"

    local loop_dev="$(losetup -f)"

    # Write new image & GPT
    dd if=/dev/zero of=${hdd_img} bs=${IMAGE_SIZE} count=1
    sgdisk -o ${hdd_img}

    # Partition layout
    sgdisk -n 1:0:+${BOOT_SIZE} -c 1:"hassio-boot" -t 1:"C12A7328-F81F-11D2-BA4B-00A0C93EC93B" ${hdd_img}
    sgdisk -n 2:0:+${SYSTEM_SIZE} -c 2:"hassio-system0" -t 2:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" ${hdd_img}
    sgdisk -n 3:0:+${SYSTEM_SIZE} -c 3:"hassio-system1" -t 3:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" ${hdd_img}
    sgdisk -n 4:0:+${BOOTSTATE_SIZE} -c 4:"hassio-bootstate" -u 4:${BOOTSTATE_UUID} ${hdd_img}
    sgdisk -n 5:0:+${OVERLAY_SIZE} -c 5:"hassio-overlay" -t 5:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" ${hdd_img}
    sgdisk -n 6:0:+${DATA_SIZE} -c 6:"hassio-data" -t 6:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" ${hdd_img}
    sgdisk -v

    # Mount image
    kpartx -a ${hdd_img}

    # Copy data
    dd if=${boot_img} of=${loop_dev}p1 bs=512
    dd if=${rootfs_img} of=${loop_dev}p2 bs=512
    dd if=${overlay_img} of=${loop_dev}p5 bs=512
    dd if=${data_img} of=${loop_dev}p6 bs=512
    
    # Cleanup
    kpartx -d ${loop_dev}
}

