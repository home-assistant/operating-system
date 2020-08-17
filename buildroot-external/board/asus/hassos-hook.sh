#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local SPL_IMG="$(path_spl_img)"

    cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/boot.scr" \
        "${BINARIES_DIR}/rk3288-tinker.dtb"

    echo "console=tty1" > "${BOOT_DATA}/cmdline.txt"

    # Create boot binary
    rm -f "${BINARIES_DIR}/idbloader.img"
    mkimage -n rk3288 -T rksd -d "${BINARIES_DIR}/u-boot-tpl.bin" "${BINARIES_DIR}/idbloader.img"
    cat "${BINARIES_DIR}/u-boot-spl.bin" >> "${BINARIES_DIR}/idbloader.img"

    # SPL
    create_spl_image

    dd if="${BINARIES_DIR}/idbloader.img" of="${SPL_IMG}" conv=notrunc bs=512 seek=64
    dd if="${BINARIES_DIR}/u-boot-dtb.img" of="${SPL_IMG}" conv=notrunc bs=512 seek=12288
}


function hassos_post_image() {
    convert_disk_image_gz
}
