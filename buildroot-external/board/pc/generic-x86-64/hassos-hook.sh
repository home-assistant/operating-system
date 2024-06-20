#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local EFIPART_DATA="${BINARIES_DIR}/efi-part"

    mkdir -p "${BOOT_DATA}/EFI/BOOT"

    cp "${BOARD_DIR}/../grub.cfg" "${EFIPART_DATA}/EFI/BOOT/grub.cfg"
    cp "${BOARD_DIR}/cmdline.txt" "${EFIPART_DATA}/cmdline.txt"
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv-A" create
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv-A" set ORDER="A B"
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv-A" set A_OK=1
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv-A" set A_TRY=0
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv-B" create
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv-B" set ORDER="B A"
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv-B" set B_OK=1
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv-B" set B_TRY=0
    cp "${EFIPART_DATA}/EFI/BOOT/grubenv-A" "${EFIPART_DATA}/EFI/BOOT/grubenv"

    cp -r "${EFIPART_DATA}/"* "${BOOT_DATA}/"
}


function hassos_post_image() {
    convert_disk_image_xz
}

