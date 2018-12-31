#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local SPL="${BINARIES_DIR}/sunxi-spl.bin"
    local UBOOT="${BINARIES_DIR}/u-boot.itb"
    local spl_img="$(path_spl_img)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    cp "${BINARIES_DIR}/sun50i-h5-orangepi-prime.dtb" "${BOOT_DATA}/sun50i-h5-orangepi-prime.dtb"
    touch "${BOOT_DATA}/cmdline.txt"
    touch "${BOOT_DATA}/config.txt"

    # SPL
    create_spl_image

    dd if="${SPL}" of="${spl_img}" conv=notrunc bs=512 seek=16
    dd if="${UBOOT}" of="${spl_img}" conv=notrunc bs=512 seek=80
}


function hassos_post_image() {
    convert_disk_image_gz
}
