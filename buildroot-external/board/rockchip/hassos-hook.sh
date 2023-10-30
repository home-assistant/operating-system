#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local SPL_IMG="$(path_spl_img)"

    cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/boot.scr" \
        "${BINARIES_DIR}/rk3288-tinker.dtb" \
        "${BINARIES_DIR}/rk3288-tinker-s.dtb"

    mkdir -p "${BOOT_DATA}/overlays"
    cp "${BINARIES_DIR}"/*.dtbo "${BOOT_DATA}/overlays/"
    cp "${BOARD_DIR}/boot-env.txt" "${BOOT_DATA}/haos-config.txt"

    echo "console=tty1" > "${BOOT_DATA}/cmdline.txt"

    # SPL
    create_spl_image

    dd if="${BINARIES_DIR}/idbloader.img" of="${SPL_IMG}" conv=notrunc bs=512 seek=64
    dd if="${BINARIES_DIR}/u-boot-dtb.img" of="${SPL_IMG}" conv=notrunc bs=512 seek=8192
}


function hassos_post_image() {
    convert_disk_image_xz
}
