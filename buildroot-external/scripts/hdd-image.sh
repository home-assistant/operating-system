#!/bin/bash

BOOT_UUID="b3dd0952-733c-4c88-8cba-cab9b8b4377f"
BOOTSTATE_UUID="33236519-7F32-4DFF-8002-3390B62C309D"
SYSTEM0_UUID="8d3d53e3-6d49-4c38-8349-aff6859e82fd"
SYSTEM1_UUID="a3ec664e-32ce-4665-95ea-7ae90ce9aa20"
KERNEL0_UUID="26700fc6-b0bc-4ccf-9837-ea1a4cba3e65"
KERNEL1_UUID="fc02a4f0-5350-406f-93a2-56cbed636b5f"
OVERLAY_UUID="f1326040-5236-40eb-b683-aaa100a9afcf"
DATA_UUID="a52a4597-fa3a-4851-aefd-2fbe9f849079"

SPL_SIZE=8M
BOOT_SIZE=(32M 24M)
BOOTSTATE_SIZE=8M
SYSTEM_SIZE=256M
KERNEL_SIZE=24M
OVERLAY_SIZE=96M
DATA_SIZE=1G


function get_boot_size() {
    if [ "${BOOT_SYS}" == "spl" ]; then
        echo "${BOOT_SIZE[1]}"
    else
        echo "${BOOT_SIZE[0]}"
    fi
}


function create_spl_image() {
    local spl_data="${BINARIES_DIR}/${1}"
    local spl_img="${BINARIES_DIR}/spl.img"
    local spl_seek=$(($2-2))

    dd if=/dev/zero of=${spl_img} bs=512 count=16382
    dd if=${spl_data} of=${spl_img} conv=notrunc bs=512 seek=${spl_seek} 
}


function create_boot_image() {
    local boot_data="${BINARIES_DIR}/boot"
    local boot_img="${BINARIES_DIR}/boot.vfat"

    echo "mtools_skip_check=1" > ~/.mtoolsrc
    dd if=/dev/zero of=${boot_img} bs=$(get_boot_size) count=1
    mkfs.vfat -n "hassos-boot" ${boot_img}
    mcopy -i ${boot_img} -sv ${boot_data}/* ::
}


function create_overlay_image() {
    local overlay_img="${BINARIES_DIR}/overlay.ext4"

    dd if=/dev/zero of=${overlay_img} bs=${OVERLAY_SIZE} count=1
    mkfs.ext4 -L "hassos-overlay" -E lazy_itable_init=0,lazy_journal_init=0 ${overlay_img}
}


function create_kernel_image() {
    local kernel_img="${BINARIES_DIR}/kernel.ext4"
    local kernel="${BINARIES_DIR}/${KERNEL_FILE}"

    # Make image
    dd if=/dev/zero of=${kernel_img} bs=${KERNEL_SIZE} count=1
    mkfs.ext4 -L "hassos-kernel" -E lazy_itable_init=0,lazy_journal_init=0 ${kernel_img}

    # Mount / init file structs
    mkdir -p /mnt/data/
    mount -o loop ${kernel_img} /mnt/data
    cp -f ${kernel} /mnt/data/
    umount /mnt/data
}


function prepare_disk_image() {
    create_boot_image
    create_overlay_image
    create_kernel_image
}


function create_disk_image() {
    local boot_img="${BINARIES_DIR}/boot.vfat"
    local rootfs_img="${BINARIES_DIR}/rootfs.squashfs"
    local overlay_img="${BINARIES_DIR}/overlay.ext4"
    local data_img="${BINARIES_DIR}/data.ext4"
    local kernel_img="${BINARIES_DIR}/kernel.ext4"
    local hdd_img="$(hassos_image_name img)"
    local hdd_count=${1:-2}

    local boot_offset=0
    local rootfs_offset=0
    local kernel_offset=0
    local overlay_offset=0
    local data_offset=0

    ##
    # Write new image & GPT
    dd if=/dev/zero of=${hdd_img} bs=1G count=${hdd_count}
    sgdisk -o ${hdd_img}

    ##
    # Partition layout

    # SPL
    if [ "${BOOT_SYS}" == "spl" ]; then
        sgdisk -j 16384 ${hdd_img}
    fi

    # boot
    boot_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 0:${boot_offset}:+$(get_boot_size) -c 0:"hassos-boot" -t 0:"C12A7328-F81F-11D2-BA4B-00A0C93EC93B" -u 0:${BOOT_UUID} ${hdd_img}

    # Kernel 0
    kernel_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 0:0:+${KERNEL_SIZE} -c 0:"hassos-kernel0" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 0:${KERNEL0_UUID} ${hdd_img}

    # System 0
    rootfs_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 0:0:+${SYSTEM_SIZE} -c 0:"hassos-system0" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 0:${SYSTEM0_UUID} ${hdd_img}

    # Kernel 1
    sgdisk -n 0:0:+${KERNEL_SIZE} -c 0:"hassos-kernel1" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 0:${KERNEL1_UUID} ${hdd_img}

    # System 1
    sgdisk -n 0:0:+${SYSTEM_SIZE} -c 0:"hassos-system1" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 0:${SYSTEM1_UUID} ${hdd_img}

    # Bootstate
    sgdisk -n 0:0:+${BOOTSTATE_SIZE} -c 0:"hassos-bootstate" -u 0:${BOOTSTATE_UUID} ${hdd_img}

    # Overlay
    overlay_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 0:0:+${OVERLAY_SIZE} -c 0:"hassos-overlay" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 0:${OVERLAY_UUID} ${hdd_img}

    # Data
    data_offset="$(sgdisk -F ${hdd_img})"
    sgdisk -n 0:0:+${DATA_SIZE} -c 0:"hassos-data" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u 0:${DATA_UUID} ${hdd_img}

    ##
    # Write Images
    sgdisk -v
    dd if=${boot_img} of=${hdd_img} conv=notrunc bs=512 seek=${boot_offset}
    dd if=${kernel_img} of=${hdd_img} conv=notrunc bs=512 seek=${kernel_offset}
    dd if=${rootfs_img} of=${hdd_img} conv=notrunc bs=512 seek=${rootfs_offset}
    dd if=${overlay_img} of=${hdd_img} conv=notrunc bs=512 seek=${overlay_offset}
    dd if=${data_img} of=${hdd_img} conv=notrunc bs=512 seek=${data_offset}

    # Fix boot
    if [ "${BOOT_SYS}" == "mbr" ]; then
        fix_disk_image_mbr
    elif [ "${BOOT_SYS}" == "spl" ]; then
        fix_disk_image_spl
    fi
}


function fix_disk_image_mbr() {
    local hdd_img="$(hassos_image_name img)"

    sgdisk -t 1:"E3C9E316-0B5C-4DB8-817D-F92DF00215AE" ${hdd_img}
    dd if=${BR2_EXTERNAL_HASSOS_PATH}/misc/mbr.img of=${hdd_img} conv=notrunc bs=512 count=1
}


function fix_disk_image_spl() {
    local hdd_img="$(hassos_image_name img)"
    local spl_img="${BINARIES_DIR}/spl.img"

    sgdisk -t 1:"E3C9E316-0B5C-4DB8-817D-F92DF00215AE" ${hdd_img}
    dd if=${spl_img} of=${hdd_img} conv=notrunc bs=512 seek=2
}


function convert_disk_image_vmdk() {
    local hdd_img="$(hassos_image_name img)"
    local hdd_vmdk="$(hassos_image_name vmdk)"

    rm -f ${hdd_vmdk}
    qemu-img convert -O vmdk ${hdd_img} ${hdd_vmdk}
    rm -f ${hdd_img}
}


function convert_disk_image_gz() {
    local hdd_img="$(hassos_image_name img)"

    rm -f ${hdd_img}.gz
    gzip --best ${hdd_img}
}
