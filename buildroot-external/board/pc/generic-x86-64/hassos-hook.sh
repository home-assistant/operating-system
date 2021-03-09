#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    mkdir -p "${BOOT_DATA}/EFI/BOOT"
    mkdir -p "${BOOT_DATA}/EFI/barebox"

    cp "${BINARIES_DIR}/barebox.bin" "${BOOT_DATA}/EFI/BOOT/BOOTx64.EFI"
    cp "${BR2_EXTERNAL_HASSOS_PATH}/bootloader/barebox-state-efi.dtb" "${BOOT_DATA}/EFI/barebox/state.dtb"

    echo "console=tty1" > "${BOOT_DATA}/cmdline.txt"
}


function hassos_post_image() {
    convert_disk_image_xz
}

