#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    cp "${BINARIES_DIR}/exynos5422-odroidxu4.dtb" "${BOOT_DATA}/exynos5422-odroidxu4.dtb"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"
}


function hassos_post_image() {
    convert_disk_image_xz
}
