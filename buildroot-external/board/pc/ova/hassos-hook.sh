#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    mkdir -p "${BOOT_DATA}/EFI/BOOT"
    mkdir -p "${BOOT_DATA}/EFI/barebox"

    cp "${BINARIES_DIR}/barebox.bin" "${BOOT_DATA}/EFI/BOOT/BOOTx64.EFI"
    cp "${BR2_EXTERNAL_HASSOS_PATH}/bootloader/barebox-state-efi.dtb" "${BOOT_DATA}/EFI/barebox/state.dtb"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"
}


function hassos_post_image() {
    local hdd_img="$(hassos_image_name img)"

    # Virtual Disk images
    convert_disk_image_virtual

    convert_disk_image_zip vmdk
    convert_disk_image_zip vhdx
    convert_disk_image_zip vdi
    convert_disk_image_xz qcow2

    # OVA
    convert_disk_image_ova

    # Cleanup
    rm -f "${hdd_img}"
}
