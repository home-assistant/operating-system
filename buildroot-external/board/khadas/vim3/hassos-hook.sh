#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local UBOOT_GXL="${BINARIES_DIR}/u-boot.gxl"
    local SPL_IMG="$(path_spl_img)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    cp "${BINARIES_DIR}/meson-g12b-s922x-khadas-vim3.dtb" "${BOOT_DATA}/meson-g12b-s922x-khadas-vim3.dtb"

    cp "${BOARD_DIR}/boot-env.txt" "${BOOT_DATA}/haos-config.txt"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"

    # SPL
    create_spl_image

    dd if="${UBOOT_GXL}" of="${SPL_IMG}" conv=notrunc bs=1 count=444
    dd if="${UBOOT_GXL}" of="${SPL_IMG}" conv=notrunc bs=512 skip=1 seek=1
}


function hassos_post_image() {
    convert_disk_image_xz
}

