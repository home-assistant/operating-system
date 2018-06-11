#!/bin/bash

BOOT_UUID="b3dd0952-733c-4c88-8cba-cab9b8b4377f"
BOOTSTATE_UUID="33236519-7F32-4DFF-8002-3390B62C309D"
SYSTEM0_UUID="8d3d53e3-6d49-4c38-8349-aff6859e82fd"
SYSTEM1_UUID="a3ec664e-32ce-4665-95ea-7ae90ce9aa20"
KERNEL0_UUID="26700fc6-b0bc-4ccf-9837-ea1a4cba3e65"
KERNEL1_UUID="fc02a4f0-5350-406f-93a2-56cbed636b5f"
OVERLAY_UUID="f1326040-5236-40eb-b683-aaa100a9afcf"
DATA_UUID="a52a4597-fa3a-4851-aefd-2fbe9f849079"

BOOT_SIZE=32M
BOOTSTATE_SIZE=8M
SYSTEM_SIZE=256M
KERNEL_SIZE=24M
OVERLAY_SIZE=96M
DATA_SIZE=1G


function create_boot_image() {
    local boot_data="${1}/boot"
    local boot_img="${1}/boot.vfat"

    echo "mtools_skip_check=1" > ~/.mtoolsrc
    dd if=/dev/zero of=${boot_img} bs=${BOOT_SIZE} count=1
    mkfs.vfat -n "hassos-boot" ${boot_img}
    mcopy -i ${boot_img} -sv ${boot_data}/* ::
}


function create_overlay_image() {
    local overlay_img="${1}/overlay.ext4"

    dd if=/dev/zero of=${overlay_img} bs=${OVERLAY_SIZE} count=1
    mkfs.ext4 -L "hassos-overlay" -E lazy_itable_init=0,lazy_journal_init=0 ${overlay_img}
}


function create_kernel_image() {
    local kernel0_img="${1}/kernel0.ext4"
    local kernel1_img="${1}/kernel1.ext4"
    local kernel=${1}/${2}

    # Make image
    dd if=/dev/zero of=${kernel0_img} bs=${KERNEL_SIZE} count=1
    mkfs.ext4 -L "hassos-kernel0" -E lazy_itable_init=0,lazy_journal_init=0 ${kernel0_img}
    dd if=/dev/zero of=${kernel1_img} bs=${KERNEL_SIZE} count=1
    mkfs.ext4 -L "hassos-kernel1" -E lazy_itable_init=0,lazy_journal_init=0 ${kernel1_img}

    # Mount / init file structs
    mkdir -p /mnt/data/
    mount -o loop ${kernel0_img} /mnt/data
    cp -f ${kernel} /mnt/data/
    umount /mnt/data
}


function create_disk_image() {
    local boot_img="${1}/boot.vfat"
    local rootfs_img="${1}/rootfs.squashfs"
    local overlay_img="${1}/overlay.ext4"
    local data_img="${1}/data.ext4"
    local kernel0_img="${1}/kernel0.ext4"
    local kernel1_img="${1}/kernel1.ext4"
    local hdd_img=${2}
    local hdd_count=${3:-2}

    local loop_dev="/dev/mapper/$(losetup -f | cut -d'/' -f3)"
    local boot_offset=0
    local rootfs_offset=0
    local kernel0_offset=0
    local kernel1_offset=0
    local overlay_offset=0
    local data_offset=0

    # Write new image & GPT
    dd if=/dev/zero of=${hdd_img} bs=1G count=${hdd_count}
    sgdisk -o ${hdd_img}

    # Partition layout
    boot_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 1:0:+${BOOT_SIZE} -c 1:"hassos-boot" -t 1:"C12A7328-F81F-11D2-BA4B-00A0C93EC93B" -u 1:${BOOT_UUID} ${hdd_img}

    kernel0_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 2:0:+${KERNEL_SIZE} -c 2:"hassos-kernel0" -t 2:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 2:${KERNEL0_UUID} ${hdd_img}

    rootfs_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 3:0:+${SYSTEM_SIZE} -c 3:"hassos-system0" -t 3:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 3:${SYSTEM0_UUID} ${hdd_img}

    kernel1_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 4:0:+${KERNEL_SIZE} -c 4:"hassos-kernel1" -t 4:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 4:${KERNEL1_UUID} ${hdd_img}

    sgdisk -n 5:0:+${SYSTEM_SIZE} -c 5:"hassos-system1" -t 5:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 5:${SYSTEM1_UUID} ${hdd_img}

    sgdisk -n 6:0:+${BOOTSTATE_SIZE} -c 6:"hassos-bootstate" -u 6:${BOOTSTATE_UUID} ${hdd_img}

    overlay_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 7:0:+${OVERLAY_SIZE} -c 7:"hassos-overlay" -t 7:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 7:${OVERLAY_UUID} ${hdd_img}

    data_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 8:0:+${DATA_SIZE} -c 8:"hassos-data" -t 8:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 8:${DATA_UUID} ${hdd_img}

    # Write Images
    sgdisk -v
    dd if=${boot_img} of=${hdd_img} conv=notrunc bs=512 obs=512 seek=${boot_offset}
    dd if=${kernel0_img} of=${hdd_img} conv=notrunc bs=512 obs=512 seek=${kernel0_offset}
    dd if=${kernel1_img} of=${hdd_img} conv=notrunc bs=512 obs=512 seek=${kernel1_offset}
    dd if=${rootfs_img} of=${hdd_img} conv=notrunc bs=512 obs=512 seek=${rootfs_offset}
    dd if=${overlay_img} of=${hdd_img} conv=notrunc bs=512 obs=512 seek=${overlay_offset}
    dd if=${data_img} of=${hdd_img} conv=notrunc bs=512 obs=512 seek=${data_offset}
}


function fix_disk_image_mbr() {
    local hdd_img=${1}

    sgdisk -t 1:"E3C9E316-0B5C-4DB8-817D-F92DF00215AE" ${hdd_img}
    dd if=${BR2_EXTERNAL_HASSOS_PATH}/misc/mbr.img of=${hdd_img} conv=notrunc bs=512 count=1
}
