#!/bin/bash

BOOTSTATE_SIZE=8M
SYSTEM_SIZE=256M
KERNEL_SIZE=24M
OVERLAY_SIZE=96M
DATA_SIZE=1280M

function create_disk_image() {
    if [ -f "${BOARD_DIR}/genimage.cfg" ]; then
      echo "Using custom genimage.cfg from ${BOARD_DIR}"
    else
      echo "Using default genimage.cfg"
    fi

    export GENIMAGE_INPUTPATH="${BINARIES_DIR}"
    export GENIMAGE_OUTPUTPATH="${BINARIES_DIR}"
    export GENIMAGE_TMPPATH="${BUILD_DIR}/genimage.tmp"

    # variables from meta file
    export DISK_SIZE BOOTLOADER KERNEL_FILE PARTITION_TABLE_TYPE BOOT_SIZE BOOT_SPL BOOT_SPL_SIZE
    # variables used in raucb manifest template
    ota_compatible="$(hassos_rauc_compatible)"
    ota_version="$(hassos_version)"
    export ota_compatible ota_version
    # variables used in genimage configs
    export BOOTSTATE_SIZE SYSTEM_SIZE KERNEL_SIZE OVERLAY_SIZE DATA_SIZE
    RAUC_MANIFEST=$(tempio -template "${BR2_EXTERNAL_HASSOS_PATH}/ota/manifest.raucm.gtpl")
    IMAGE_NAME="$(hassos_image_basename)"
    BOOT_SPL_TYPE=$(test "$BOOT_SPL" == "true" && echo "spl" || echo "nospl")
    export RAUC_MANIFEST IMAGE_NAME BOOT_SPL_TYPE
    SYSTEM_IMAGE=$(path_rootfs_img)
    DATA_IMAGE=$(path_data_img)
    export SYSTEM_IMAGE DATA_IMAGE

    trap 'rm -rf "${ROOTPATH_TMP}" "${GENIMAGE_TMPPATH}"' EXIT
    ROOTPATH_TMP="$(mktemp -d)"

    rm -rf "${GENIMAGE_TMPPATH}"
    # Generate boot FS image - run in a separate step with specific rootpath
    genimage \
      --rootpath "$(path_boot_dir)" \
      --configdump - \
      --includepath "${BOARD_DIR}:${BR2_EXTERNAL_HASSOS_PATH}/genimage" \
      --config images-boot.cfg

    rm -rf "${GENIMAGE_TMPPATH}"
    # Generate OS image (no files are copied to temporary rootpath here)
    genimage \
      --rootpath "${ROOTPATH_TMP}" \
      --configdump - \
      --includepath "${BOARD_DIR}:${BR2_EXTERNAL_HASSOS_PATH}/genimage"
}

function convert_disk_image_virtual() {
    local hdd_ext="${1}"
    local hdd_img
    hdd_img="$(hassos_image_name img)"
    local hdd_virt
    hdd_virt="$(hassos_image_name "${hdd_ext}")"
    local -a qemu_img_opts=()

    if [ "${hdd_ext}" == "vmdk" ]; then
        qemu_img_opts=("-o" "adapter_type=lsilogic")
    fi

    rm -f "${hdd_virt}"

    qemu-img convert -O "${hdd_ext}" "${qemu_img_opts[@]}" "${hdd_img}" "${hdd_virt}"
}

function convert_disk_image_ova() {
    local hdd_img
    hdd_img="$(hassos_image_name img)"
    local hdd_ova
    hdd_ova="$(hassos_image_name ova)"
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
    local hdd_img
    hdd_img="$(hassos_image_name "${hdd_ext}")"

    rm -f "${hdd_img}.xz"
    xz -3 -T0 "${hdd_img}"
}

function convert_disk_image_zip() {
    local hdd_ext=${1:-img}
    local hdd_img
    hdd_img="$(hassos_image_name "${hdd_ext}")"

    rm -f "${hdd_img}.zip"
    zip -j -m -q -r "${hdd_img}.zip" "${hdd_img}"
}
