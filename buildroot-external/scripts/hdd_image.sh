#!/bin/bash

BOOTSTATE_UUID="33236519-7F32-4DFF-8002-3390B62C309D"
OVERLAY_BLOCK=131071
DATA_BLOCK=131071
BOOT_BLOCK=65535

function hassio_boot_image() {
    local boot_data=$1
    local boot_img=$2

    echo "mtools_skip_check=1" > ~/.mtoolsrc
    dd if=/dev/zero of=${boot_img} bs=512 count=${BOOT_BLOCK}
    mkfs.vfat -n "hassio-boot" ${boot_img}
    mcopy -i ${boot_img} -sv ${boot_data}/* ::
}

function hassio_overlay_image() {
    local overlay_img=$1

    dd if=/dev/zero of=${overlay_img} bs=512 count=${OVERLAY_BLOCK}
    mkfs.ext4 ${overlay_img}
    tune2fs -L "hassio-overlay" -c0 -i0 ${overlay_img}
}

function hassio_data_image() {
    local data_img=$1

    dd if=/dev/zero of=${data_img} bs=512 count=${DATA_BLOCK}
    mkfs.ext4 ${data_img}
    tune2fs -L "hassio-data" -c0 -i0 ${data_img}
}

function hassio_hdd_image() {
    local boot_img=$1
    local rootfs_img=$2
    local overlay_img=$3
    local data_img=$4
    local hdd_img=$5

    local boot_size="+32M"
    local boot_offset=0
    local rootfs_size="+256M"
    local rootfs_offset=0
    local overlay_size="+64M"
    local overlay_offset=0
    local data_size="+64M"
    local data_offset=0
    local bootstate_size="+8M"


    # Write new image & GPT
    dd if=/dev/zero of=${hdd_img} bs=1024K count=800
    sgdisk -o ${hdd_img}
    echo "GPT formating done"

    # Boot
    boot_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 1:${boot_offset}:${boot_size} -c 1:"hassio-boot" -t 1:"C12A7328-F81F-11D2-BA4B-00A0C93EC93B" ${hdd_img}
    dd if=${boot_img} of=${hdd_img} conv=notrunc bs=512 seek=${boot_offset}
    echo "Boot formating done"

    # System0
    rootfs_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 2:${rootfs_offset}:${rootfs_size} -c 2:"hassio-system0" -t 2:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" ${hdd_img}
    dd if=${rootfs_img} of=${hdd_img} conv=notrunc bs=512 seek=${rootfs_offset}
    echo "System0 formating done"

    # System1
    sgdisk -n 3:0:${rootfs_size} -c 3:"hassio-system1" -t 3:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" ${hdd_img}
    echo "System1 formating done"

    # BootState
    sgdisk -n 4:0:${bootstate_size} -c 4:"hassio-bootstate" -u 4:${BOOTSTATE_UUID} ${hdd_img}
    echo "BootState formating done"

    # Overlay
    overlay_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 5:${overlay_offset}:${overlay_size} -c 5:"hassio-overlay" -t 5:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" ${hdd_img}
    dd if=${overlay_img} of=${hdd_img} conv=notrunc bs=512 seek=${overlay_offset}
    echo "Overlay formating done"

    # Data
    data_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 6:${data_offset}:${data_size} -c 6:"hassio-data" -t 6:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" ${hdd_img}
    dd if=${data_img} of=${hdd_img} conv=notrunc bs=512 seek=${data_offset}
    echo "Data formating done"
}

