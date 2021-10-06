#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local BL1="${BINARIES_DIR}/bl1.bin.hardkernel"
    local UBOOT_GXBB="${BINARIES_DIR}/u-boot.gxbb"
    local SPL_IMG="$(path_spl_img)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    cp "${BINARIES_DIR}/meson-gxbb-odroidc2.dtb" "${BOOT_DATA}/meson-gxbb-odroidc2.dtb"

    mkdir -p "${BOOT_DATA}/overlays"
    cp "${BINARIES_DIR}"/*.dtbo "${BOOT_DATA}/overlays/"
    cp "${BOARD_DIR}/boot-env.txt" "${BOOT_DATA}/haos-config.txt"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"

    # SPL
    create_spl_image

    dd if="${BL1}" of="${SPL_IMG}" conv=notrunc bs=1 count=440
    dd if="${BL1}" of="${SPL_IMG}" conv=notrunc bs=512 skip=1 seek=1
    dd if="${UBOOT_GXBB}" of="${SPL_IMG}" conv=notrunc bs=512 seek=97
}


function hassos_post_image() {
    convert_disk_image_xz
}

