#!/bin/bash
# shellcheck disable=SC2155

BOOT_UUID="b3dd0952-733c-4c88-8cba-cab9b8b4377f"
BOOTSTATE_UUID="33236519-7F32-4DFF-8002-3390B62C309D"
SYSTEM0_UUID="8d3d53e3-6d49-4c38-8349-aff6859e82fd"
SYSTEM1_UUID="a3ec664e-32ce-4665-95ea-7ae90ce9aa20"
KERNEL0_UUID="26700fc6-b0bc-4ccf-9837-ea1a4cba3e65"
KERNEL1_UUID="fc02a4f0-5350-406f-93a2-56cbed636b5f"
OVERLAY_UUID="f1326040-5236-40eb-b683-aaa100a9afcf"
DATA_UUID="a52a4597-fa3a-4851-aefd-2fbe9f849079"

BOOT_SIZE=(32M 24M)
BOOTSTATE_SIZE=8M
SYSTEM_SIZE=256M
KERNEL_SIZE=24M
OVERLAY_SIZE=96M
DATA_SIZE=1G


function size2sectors() {
    local f=0
    for v in "${@}"
    do
    local p=$(echo "$v" | awk \
      'BEGIN{IGNORECASE = 1}
       function printsectors(n,b,p) {printf "%u\n", n*b^p/512}
       /B$/{     printsectors($1,  1, 0)};
       /K(iB)?$/{printsectors($1,  2, 10)};
       /M(iB)?$/{printsectors($1,  2, 20)};
       /G(iB)?$/{printsectors($1,  2, 30)};
       /T(iB)?$/{printsectors($1,  2, 40)};
       /KB$/{    printsectors($1, 10,  3)};
       /MB$/{    printsectors($1, 10,  6)};
       /GB$/{    printsectors($1, 10,  9)};
       /TB$/{    printsectors($1, 10, 12)}')
    for s in $p
    do
        f=$((f+s))
    done

    done
    echo $f
}


function get_boot_size() {
    if [ "${BOOT_SYS}" == "spl" ]; then
        echo "${BOOT_SIZE[1]}"
    else
        echo "${BOOT_SIZE[0]}"
    fi
}


function create_spl_image() {
    local boot_img="$(path_spl_img)"

    dd if=/dev/zero of="${boot_img}" bs=512 count=16382
}


function create_boot_image() {
    local boot_data="$(path_boot_dir)"
    local boot_img="$(path_boot_img)"

    echo "mtools_skip_check=1" > ~/.mtoolsrc
    dd if=/dev/zero of="${boot_img}" bs="$(get_boot_size)" count=1
    mkfs.vfat -n "hassos-boot" "${boot_img}"
    mcopy -i "${boot_img}" -sv "${boot_data}"/* ::
}


function create_overlay_image() {
    local overlay_img="$(path_overlay_img)"

    dd if=/dev/zero of="${overlay_img}" bs=${OVERLAY_SIZE} count=1
    mkfs.ext4 -L "hassos-overlay" -E lazy_itable_init=0,lazy_journal_init=0 "${overlay_img}"
}


function create_kernel_image() {
    local kernel_img="$(path_kernel_img)"
    # shellcheck disable=SC2153
    local kernel="${BINARIES_DIR}/${KERNEL_FILE}"

    # Make image
    dd if=/dev/zero of="${kernel_img}" bs=${KERNEL_SIZE} count=1
    mkfs.ext4 -L "hassos-kernel" -E lazy_itable_init=0,lazy_journal_init=0 -O ^extent,^64bit "${kernel_img}"

    # Mount / init file structs
    sudo mkdir -p /mnt/data/
    sudo mount -o loop "${kernel_img}" /mnt/data
    sudo cp "${kernel}" /mnt/data/
    sudo umount /mnt/data
}


function _prepare_disk_image() {
    create_boot_image
    create_overlay_image
    create_kernel_image
}


function create_disk_image() {
    _prepare_disk_image

    if [ "${BOOT_SYS}" == "mbr" ]; then
        _create_disk_mbr
    else
        _create_disk_gpt
    fi
}


function _create_disk_gpt() {
    local boot_img="$(path_boot_img)"
    local rootfs_img="$(path_rootfs_img)"
    local overlay_img="$(path_overlay_img)"
    local data_img="$(path_data_img)"
    local kernel_img="$(path_kernel_img)"
    local hdd_img="$(hassos_image_name img)"
    local hdd_count=${DISK_SIZE:-2}

    local boot_offset=0
    local rootfs_offset=0
    local kernel_offset=0
    local overlay_offset=0
    local data_offset=0

    ##
    # Write new image & GPT
    dd if=/dev/zero of="${hdd_img}" bs=1G count="${hdd_count}"
    sgdisk -o "${hdd_img}"

    ##
    # Partition layout

    # SPL
    if [ "${BOOT_SYS}" == "spl" ]; then
        sgdisk -j 16384 "${hdd_img}"
    fi

    # boot
    boot_offset="$(sgdisk -F "${hdd_img}")"
    sgdisk -n "0:${boot_offset}:+$(get_boot_size)" -c 0:"hassos-boot" -t 0:"C12A7328-F81F-11D2-BA4B-00A0C93EC93B" -u 0:${BOOT_UUID} "${hdd_img}"

    # Kernel 0
    kernel_offset="$(sgdisk -F "${hdd_img}")"
    sgdisk -n "0:0:+${KERNEL_SIZE}" -c 0:"hassos-kernel0" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u "0:${KERNEL0_UUID}" "${hdd_img}"

    # System 0
    rootfs_offset="$(sgdisk -F "${hdd_img}")"
    sgdisk -n "0:0:+${SYSTEM_SIZE}" -c 0:"hassos-system0" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u "0:${SYSTEM0_UUID}" "${hdd_img}"

    # Kernel 1
    sgdisk -n "0:0:+${KERNEL_SIZE}" -c 0:"hassos-kernel1" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u "0:${KERNEL1_UUID}" "${hdd_img}"

    # System 1
    sgdisk -n "0:0:+${SYSTEM_SIZE}" -c 0:"hassos-system1" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u "0:${SYSTEM1_UUID}" "${hdd_img}"

    # Bootstate
    sgdisk -n "0:0:+${BOOTSTATE_SIZE}" -c 0:"hassos-bootstate" -u 0:${BOOTSTATE_UUID} "${hdd_img}"

    # Overlay
    overlay_offset="$(sgdisk -F "${hdd_img}")"
    sgdisk -n "0:0:+${OVERLAY_SIZE}" -c 0:"hassos-overlay" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u "0:${OVERLAY_UUID}" "${hdd_img}"

    # Data
    data_offset="$(sgdisk -F "${hdd_img}")"
    sgdisk -n "0:0:+${DATA_SIZE}" -c 0:"hassos-data" -t 0:"0FC63DAF-8483-4772-8E79-3D69D8477DE4" -u "0:${DATA_UUID}" "${hdd_img}"

    ##
    # Write Images
    sgdisk -v
    dd if="${boot_img}" of"=${hdd_img}" conv=notrunc bs=512 seek="${boot_offset}"
    dd if="${kernel_img}" of="${hdd_img}" conv=notrunc bs=512 seek="${kernel_offset}"
    dd if="${rootfs_img}" of="${hdd_img}" conv=notrunc bs=512 seek="${rootfs_offset}"
    dd if="${overlay_img}" of="${hdd_img}" conv=notrunc bs=512 seek="${overlay_offset}"
    dd if="${data_img}" of="${hdd_img}" conv=notrunc bs=512 seek="${data_offset}"

    # Fix boot
    if [ "${BOOT_SYS}" == "hyprid" ]; then
        _fix_disk_hyprid
    elif [ "${BOOT_SYS}" == "spl" ]; then
        _fix_disk_spl_gpt
    fi
}


function _create_disk_mbr() {
    local boot_img="$(path_boot_img)"
    local rootfs_img="$(path_rootfs_img)"
    local overlay_img="$(path_overlay_img)"
    local data_img="$(path_data_img)"
    local kernel_img="$(path_kernel_img)"
    local hdd_img="$(hassos_image_name img)"
    local hdd_count=${DISK_SIZE:-2}
    local disk_layout="${BINARIES_DIR}/disk.layout"
    local boot_start=16384

    local boot_size=$(($(size2sectors "$(get_boot_size)")+2))
    local kernel0_size=$(($(size2sectors "$KERNEL_SIZE")+2))
    local system0_size=$(($(size2sectors "$SYSTEM_SIZE")+2))
    local kernel1_size=$(($(size2sectors "$KERNEL_SIZE")+2))
    local system1_size=$(($(size2sectors "$SYSTEM_SIZE")+2))
    local bootstate_size=$(($(size2sectors "$BOOTSTATE_SIZE")+2))
    local overlay_size=$(($(size2sectors "$OVERLAY_SIZE")+2))
    local data_size=$(($(size2sectors "$DATA_SIZE")+2))
    local extended_size=$((kernel0_size+system0_size+kernel1_size+system1_size+bootstate_size+2))

    # we add one here for the extended header.
    local extended_start=$((boot_start+boot_size+1))
    local kernel0_start=$((extended_start+1))
    local system0_start=$((kernel0_start+kernel0_size+1))
    local kernel1_start=$((system0_start+system0_size+1))
    local system1_start=$((kernel1_start+kernel1_size+1))
    local bootstate_start=$((system1_start+system1_size+1))
    local overlay_start=$((extended_start+extended_size+1))
    local data_start=$((overlay_start+overlay_size+1))

    local boot_offset=${boot_start}
    local kernel_offset=${kernel0_start}
    local rootfs_offset=${system0_start}
    local overlay_offset=${overlay_start}
    local data_offset=${data_start}

    # Write new image & MBR
    dd if=/dev/zero of="${hdd_img}" bs=1G count="${hdd_count}"

    # Update disk layout
    (
        echo "label: dos"
        echo "label-id: 0x48617373"
        echo "unit: sectors"
        echo "hassos-boot      : start= ${boot_start},      size=  ${boot_size},       type=c, bootable"   #create the boot partition
        echo "hassos-extended  : start= ${extended_start},  size=  ${extended_size},   type=5"             #Make an extended partition
        echo "hassos-kernel    : start= ${kernel0_start},   size=  ${kernel0_size},    type=83"            #Make a logical Linux partition
        echo "hassos-system    : start= ${system0_start},   size=  ${system0_size},    type=83"            #Make a logical Linux partition
        echo "hassos-kernel    : start= ${kernel1_start}    size=  ${kernel1_size},    type=83"            #Make a logical Linux partition
        echo "hassos-system    : start= ${system1_start},   size=  ${system1_size},    type=83"            #Make a logical Linux partition
        echo "hassos-bootstate : start= ${bootstate_start}, size=  ${bootstate_size},  type=83"            #Make a logical Linux partition
        echo "hassos-overlay   : start= ${overlay_start},   size=  ${overlay_size},    type=83"            #Make a Linux partition
        echo "hassos-data      : start= ${data_start},      size=  ${data_size},       type=83"            #Make a Linux partition
    ) > "${disk_layout}"

    # Update Labels
    sfdisk "${hdd_img}" < "${disk_layout}"

    # Write Images
    dd if="${boot_img}" of="${hdd_img}" conv=notrunc bs=512 seek="${boot_offset}"
    dd if="${kernel_img}" of="${hdd_img}" conv=notrunc bs=512 seek="${kernel_offset}"
    dd if="${rootfs_img}" of="${hdd_img}" conv=notrunc bs=512 seek="${rootfs_offset}"
    dd if="${overlay_img}" of="${hdd_img}" conv=notrunc bs=512 seek="${overlay_offset}"
    dd if="${data_img}" of="${hdd_img}" conv=notrunc bs=512 seek="${data_offset}"

    # Wripte SPL
    _fix_disk_spl_mbr
}


function _fix_disk_hyprid() {
    local hdd_img="$(hassos_image_name img)"

    sgdisk -t 1:"E3C9E316-0B5C-4DB8-817D-F92DF00215AE" "${hdd_img}"
    dd if="${BR2_EXTERNAL_HASSOS_PATH}/misc/mbr.img" of="${hdd_img}" conv=notrunc bs=512 count=1
}


function _fix_disk_spl_gpt() {
    local hdd_img="$(hassos_image_name img)"
    local spl_img="$(path_spl_img)"

    sgdisk -t 1:"E3C9E316-0B5C-4DB8-817D-F92DF00215AE" "${hdd_img}"
    dd if="${BR2_EXTERNAL_HASSOS_PATH}/misc/mbr-spl.img" of="${hdd_img}" conv=notrunc bs=512 count=1
    dd if="${spl_img}" of="${hdd_img}" conv=notrunc bs=512 seek=2 skip=2
}


function _fix_disk_spl_mbr() {
    local hdd_img="$(hassos_image_name img)"
    local spl_img="$(path_spl_img)"

    # backup MBR
    dd if="${spl_img}" of="${hdd_img}" conv=notrunc bs=1 count=440
    dd if="${spl_img}" of="${hdd_img}" conv=notrunc bs=512 seek=1 skip=1
}


function convert_disk_image_virtual() {
    local hdd_img="$(hassos_image_name img)"
    local hdd_vmdk="$(hassos_image_name vmdk)"
    local hdd_vhdx="$(hassos_image_name vhdx)"
    local hdd_vdi="$(hassos_image_name vdi)"

    rm -f "${hdd_vmdk}"
    rm -f "${hdd_vhdx}"
    rm -f "${hdd_vdi}"

    qemu-img convert -O vmdk "${hdd_img}" "${hdd_vmdk}"
    qemu-img convert -O vhdx "${hdd_img}" "${hdd_vhdx}"
    qemu-img convert -O vdi "${hdd_img}" "${hdd_vdi}"

    rm -f "${hdd_img}"
}


function convert_disk_image_gz() {
    local hdd_ext=${1:-img}
    local hdd_img="$(hassos_image_name "${hdd_ext}")"

    rm -f "${hdd_img}.gz"
    gzip --best "${hdd_img}"
}
