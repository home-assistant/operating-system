#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    mkdir -p "${BOOT_DATA}/EFI/BOOT"
    cp "${BINARIES_DIR}/u-boot-payload.efi" "${BOOT_DATA}/EFI/BOOT/BOOTx64.EFI"
    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/"

    echo "console=tty1" > "${BOOT_DATA}/cmdline.txt"
}


function hassos_post_image() {
    convert_disk_image_virtual

    convert_disk_image_gz vmdk
    convert_disk_image_gz vhdx
    convert_disk_image_gz vdi
}

