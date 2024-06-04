#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local UBOOT_SM1="${BINARIES_DIR}/u-boot.sm1"
    local SPL_IMG="$(path_spl_img)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    cp "${BINARIES_DIR}/meson-sm1-odroid-c4.dtb" "${BOOT_DATA}/meson-sm1-odroid-c4.dtb"

    mkdir -p "${BOOT_DATA}/overlays"
    cp "${BINARIES_DIR}"/*.dtbo "${BOOT_DATA}/overlays/"
    cp "${BOARD_DIR}/boot-env.txt" "${BOOT_DATA}/haos-config.txt"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"

    # SPL
    create_spl_image

    dd if="${UBOOT_SM1}" of="${SPL_IMG}" conv=notrunc bs=512 seek=1
}


function hassos_post_image() {
    convert_disk_image_xz
}
