#!/bin/bash

BOOT_UUID="b3dd0952-733c-4c88-8cba-cab9b8b4377f"
BOOTSTATE_UUID="33236519-7F32-4DFF-8002-3390B62C309D"
SYSTEM0_UUID="8d3d53e3-6d49-4c38-8349-aff6859e82fd"
SYSTEM1_UUID="a3ec664e-32ce-4665-95ea-7ae90ce9aa20"
OVERLAY_UUID="f1326040-5236-40eb-b683-aaa100a9afcf"
DATA_UUID="a52a4597-fa3a-4851-aefd-2fbe9f849079"

BOOT_SIZE=32M
BOOTSTATE_SIZE=8M
SYSTEM_SIZE=256M
OVERLAY_SIZE=64M
DATA_SIZE=1G

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
    local hdd_img=${2}
    local hdd_count=${3:-2}

    local loop_dev="/dev/mapper/$(losetup -f | cut -d'/' -f3)"
    local boot_offset=0
    local rootfs_offset=0
    local overlay_offset=0
    local data_offset=0

    # Write new image & GPT
    dd if=/dev/zero of=${hdd_img} bs=1G count=${hdd_count}
    sgdisk -o ${hdd_img}

    # Partition layout
    boot_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 1:0:+${BOOT_SIZE} -c 1:"hassio-boot" -t 1:"C12A7328-F81F-11D2-BA4B-00A0C93EC93B" -u 1:${BOOT_UUID} ${hdd_img}
    rootfs_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 2:0:+${SYSTEM_SIZE} -c 2:"hassio-system0" -t 2:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 2:${SYSTEM0_UUID} ${hdd_img}
    sgdisk -n 3:0:+${SYSTEM_SIZE} -c 3:"hassio-system1" -t 3:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 3:${SYSTEM1_UUID} ${hdd_img}
    sgdisk -n 4:0:+${BOOTSTATE_SIZE} -c 4:"hassio-bootstate" -u 4:${BOOTSTATE_UUID} ${hdd_img}
    overlay_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 5:0:+${OVERLAY_SIZE} -c 5:"hassio-overlay" -t 5:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 5:${OVERLAY_UUID} ${hdd_img}
    data_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 6:0:+${DATA_SIZE} -c 6:"hassio-data" -t 6:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 6:${DATA_UUID} ${hdd_img}
    sgdisk -v

    # Write Images
    dd if=${boot_img} of=${hdd_img} conv=notrunc bs=512 obs=512 seek=${boot_offset}
    dd if=${rootfs_img} of=${hdd_img} conv=notrunc bs=512 obs=512 seek=${rootfs_offset}
    dd if=${overlay_img} of=${hdd_img} conv=notrunc bs=512 obs=512 seek=${overlay_offset}
    dd if=${data_img} of=${hdd_img} conv=notrunc bs=512 obs=512 seek=${data_offset}
}

