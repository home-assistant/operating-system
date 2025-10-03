#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    mkdir -p "${BOOT_DATA}/slot-A/"
    cp "${BINARIES_DIR}"/*.dtb "${BOOT_DATA}/slot-A/"
    gzip --stdout "${BINARIES_DIR}"/Image > "${BOOT_DATA}/slot-A/kernel_2712.img"
    cp -r "${BINARIES_DIR}/overlays/" "${BOOT_DATA}/slot-A/"
    cp "${BINARIES_DIR}"/*.dtbo "${BOOT_DATA}/slot-A/overlays/" 2>/dev/null || true
    # README needs to be present, otherwise os_prefix is not
    # prepended implicitly to the overlays' path, see:
    # https://www.raspberrypi.com/documentation/computers/config_txt.html#overlay_prefix
    touch "${BOOT_DATA}/slot-A/overlays/README" 2>/dev/null || true
    cp "${BOARD_DIR}/config.txt" "${BOOT_DATA}/config.txt"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"
}


function hassos_post_image() {
    convert_disk_image_xz
}

