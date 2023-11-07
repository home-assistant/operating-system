#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    cp "${BINARIES_DIR}"/*.dtb "${BOOT_DATA}/"
    cp "${BINARIES_DIR}"/Image "${BOOT_DATA}/kernel_2712.img"
    cp "${BOARD_DIR}/config.txt" "${BOOT_DATA}/config.txt"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"
    cp "${BINARIES_DIR}"/*.dtbo "${BOOT_DATA}/overlays/" 2>/dev/null || true
}


function hassos_post_image() {
    convert_disk_image_xz
}

