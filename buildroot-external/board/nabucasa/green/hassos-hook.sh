#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local SPL_IMG="$(path_spl_img)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    cp "${BINARIES_DIR}"/*.dtb "${BOOT_DATA}/"

    cp "${BOARD_DIR}/boot-env.txt" "${BOOT_DATA}/haos-config.txt"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"

    # SPL
    create_spl_image

    dd if="${BINARIES_DIR}/u-boot-rockchip.bin" of="${SPL_IMG}" conv=notrunc bs=512 seek=64
}


function hassos_post_image() {
    convert_disk_image_xz
}

