#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local BL1="${BINARIES_DIR}/bl1.bin.hardkernel"
    local BL2="${BINARIES_DIR}/bl2.bin.hardkernel.720k_uboot"
    local BLTZ="${BINARIES_DIR}/tzsw.bin.hardkernel"
    local UBOOT="${BINARIES_DIR}/u-boot.bin"
    local spl_img="$(path_spl_img)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    cp "${BINARIES_DIR}/exynos5422-odroidxu4.dtb" "${BOOT_DATA}/exynos5422-odroidxu4.dtb"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"

    # SPL
    create_spl_image

    dd if="${BL1}" of="${spl_img}" conv=notrunc bs=512 seek=1
    dd if="${BL2}" of="${spl_img}" conv=notrunc bs=512 seek=31
    dd if="${UBOOT}" of="${spl_img}" conv=notrunc bs=512 seek=63
    dd if="${BLTZ}" of="${spl_img}" conv=notrunc bs=512 seek=1503
    dd if=/dev/zero of="${spl_img}" conv=notrunc bs=512 count=32 seek=2015
}


function hassos_post_image() {
    convert_disk_image_xz
}
