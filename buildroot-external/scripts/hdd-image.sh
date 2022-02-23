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
DATA_SIZE=1280M


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
    if [ "${BOOT_SPL}" == "true" ]; then
        echo "${BOOT_SIZE[1]}"
    else
        echo "${BOOT_SIZE[0]}"
    fi
}


function create_spl_image() {
    local boot_img="$(path_spl_img)"

    rm -f "${boot_img}"
    truncate --size=8M "${boot_img}"
}


function create_boot_image() {
    local boot_data="$(path_boot_dir)"
    local boot_img="$(path_boot_img)"

    echo "mtools_skip_check=1" > ~/.mtoolsrc
    rm -f "${boot_img}"
    truncate --size="$(get_boot_size)" "${boot_img}"
    mkfs.vfat -n "hassos-boot" "${boot_img}"
    mcopy -i "${boot_img}" -sv "${boot_data}"/* ::
}


function create_overlay_image() {
    local overlay_img="$(path_overlay_img)"

    rm -f "${overlay_img}"
    truncate --size="${OVERLAY_SIZE}" "${overlay_img}"
    mkfs.ext4 -L "hassos-overlay" -I 256 -E lazy_itable_init=0,lazy_journal_init=0 "${overlay_img}"
}


function create_kernel_image() {
    local kernel_img="$(path_kernel_img)"
    # shellcheck disable=SC2153
    local kernel="${BINARIES_DIR}/${KERNEL_FILE}"

    # Make image
    rm -f "${kernel_img}"
    mksquashfs "${kernel}" "${kernel_img}" -comp lzo
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
    rm -f "${hdd_img}"
    truncate --size="${hdd_count}G" "${hdd_img}"
    sgdisk -o "${hdd_img}"

    ##
    # Partition layout

    # SPL
    if [ "${BOOT_SPL}" == "true" ]; then
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
    dd if="${boot_img}" of"=${hdd_img}" conv=notrunc,sparse bs=512 seek="${boot_offset}"
    dd if="${kernel_img}" of="${hdd_img}" conv=notrunc,sparse bs=512 seek="${kernel_offset}"
    dd if="${rootfs_img}" of="${hdd_img}" conv=notrunc,sparse bs=512 seek="${rootfs_offset}"
    dd if="${overlay_img}" of="${hdd_img}" conv=notrunc,sparse bs=512 seek="${overlay_offset}"
    dd if="${data_img}" of="${hdd_img}" conv=notrunc,sparse bs=512 seek="${data_offset}"

    # Set Hyprid partition
    if [ "${BOOT_SYS}" == "hybrid" ]; then
        _fix_disk_hybrid
    fi

    # Write SPL
    if [ "${BOOT_SPL}" == "true" ]; then
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
    local boot_start=$(size2sectors "8M")

    local boot_size=$(size2sectors "$(get_boot_size)")
    local kernel0_size=$(size2sectors "$KERNEL_SIZE")
    local system0_size=$(size2sectors "$SYSTEM_SIZE")
    local kernel1_size=$(size2sectors "$KERNEL_SIZE")
    local system1_size=$(size2sectors "$SYSTEM_SIZE")
    local bootstate_size=$(size2sectors "$BOOTSTATE_SIZE")
    local overlay_size=$(size2sectors "$OVERLAY_SIZE")
    local data_size=$(size2sectors "$DATA_SIZE")
    local extended_size=$((kernel0_size+system0_size+kernel1_size+system1_size+bootstate_size+5*$(size2sectors "1M")))

    # we add one here for the extended header.
    local extended_start=$((boot_start+boot_size))
    local kernel0_start=$((extended_start+$(size2sectors "1M")))
    local system0_start=$((kernel0_start+kernel0_size+$(size2sectors "1M")))
    local kernel1_start=$((system0_start+system0_size+$(size2sectors "1M")))
    local system1_start=$((kernel1_start+kernel1_size+$(size2sectors "1M")))
    local bootstate_start=$((system1_start+system1_size+$(size2sectors "1M")))
    local overlay_start=$((extended_start+extended_size+$(size2sectors "1M")))
    local data_start=$((overlay_start+overlay_size+$(size2sectors "1M")))

    local boot_offset=${boot_start}
    local kernel_offset=${kernel0_start}
    local rootfs_offset=${system0_start}
    local overlay_offset=${overlay_start}
    local data_offset=${data_start}

    # Write new image & MBR
    rm -f "${hdd_img}"
    truncate --size="${hdd_count}G" "${hdd_img}"

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
    dd if="${boot_img}" of="${hdd_img}" conv=notrunc,sparse bs=512 seek="${boot_offset}"
    dd if="${kernel_img}" of="${hdd_img}" conv=notrunc,sparse bs=512 seek="${kernel_offset}"
    dd if="${rootfs_img}" of="${hdd_img}" conv=notrunc,sparse bs=512 seek="${rootfs_offset}"
    dd if="${overlay_img}" of="${hdd_img}" conv=notrunc,sparse bs=512 seek="${overlay_offset}"
    dd if="${data_img}" of="${hdd_img}" conv=notrunc,sparse bs=512 seek="${data_offset}"

    # Write SPL
    if [ "${BOOT_SPL}" == "true" ]; then
        _fix_disk_spl_mbr
    fi
}


function _fix_disk_hybrid() {
    local hdd_img="$(hassos_image_name img)"

    sgdisk -t 1:"E3C9E316-0B5C-4DB8-817D-F92DF00215AE" "${hdd_img}"
    dd if="${BR2_EXTERNAL_HASSOS_PATH}/bootloader/mbr.img" of="${hdd_img}" conv=notrunc bs=512 count=1
}


function _fix_disk_spl_gpt() {
    local hdd_img="$(hassos_image_name img)"
    local spl_img="$(path_spl_img)"

    sgdisk -t 1:"E3C9E316-0B5C-4DB8-817D-F92DF00215AE" "${hdd_img}"
    dd if="${BR2_EXTERNAL_HASSOS_PATH}/bootloader/mbr-spl.img" of="${hdd_img}" conv=notrunc bs=512 count=1
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
    local hdd_ext="${1}"
    local hdd_img="$(hassos_image_name img)"
    local hdd_virt="$(hassos_image_name "${hdd_ext}")"
    local -a qemu_img_opts=()

    if [ "${hdd_ext}" == "vmdk" ]; then
        qemu_img_opts=("-o" "adapter_type=lsilogic")
    fi

    rm -f "${hdd_virt}"

    qemu-img convert -O "${hdd_ext}" "${qemu_img_opts[@]}" "${hdd_img}" "${hdd_virt}"
}

function convert_disk_image_ova() {
    local hdd_img="$(hassos_image_name img)"
    local hdd_ova="$(hassos_image_name ova)"
    local ova_data="${BINARIES_DIR}/ova"

    mkdir -p "${ova_data}"
    rm -f "${hdd_ova}"

    cp -a "${BOARD_DIR}/home-assistant.ovf" "${ova_data}/home-assistant.ovf"
    qemu-img convert -O vmdk -o subformat=streamOptimized,adapter_type=lsilogic "${hdd_img}" "${ova_data}/home-assistant.vmdk"
    (cd "${ova_data}" || exit 1; "${HOST_DIR}/bin/openssl" sha256 home-assistant.* >home-assistant.mf)
    tar -C "${ova_data}" --owner=root --group=root -cf "${hdd_ova}" home-assistant.ovf home-assistant.vmdk home-assistant.mf
}

function convert_disk_image_xz() {
    local hdd_ext=${1:-img}
    local hdd_img="$(hassos_image_name "${hdd_ext}")"

    rm -f "${hdd_img}.xz"
    xz -3 -T0 "${hdd_img}"
}

function convert_disk_image_zip() {
    local hdd_ext=${1:-img}
    local hdd_img="$(hassos_image_name "${hdd_ext}")"

    rm -f "${hdd_img}.zip"
    zip -j -m -q -r "${hdd_img}.zip" "${hdd_img}"
}
