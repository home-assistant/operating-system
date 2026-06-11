#!/bin/bash
# shellcheck disable=SC2155

function haos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local EFIPART_DATA="${BINARIES_DIR}/efi-part"

    mkdir -p "${BOOT_DATA}/EFI/BOOT"

    cp "${BOARD_DIR}/grub.cfg" "${EFIPART_DATA}/EFI/BOOT/grub.cfg"
    cp "${BOARD_DIR}/cmdline.txt" "${EFIPART_DATA}/cmdline.txt"
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" create
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" set ORDER="A B"
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" set A_OK=1
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" set A_TRY=0

    cp -r "${EFIPART_DATA}/"* "${BOOT_DATA}/"
}


function haos_post_image() {
    local hdd_img="$(haos_image_name img)"
    local hdd_img_orig="$(haos_image_name img.orig)"

    # Resize for VM images, preserving original
    cp "$hdd_img" "$hdd_img_orig"
    resize_disk_image_virtual 32G

    # Create VM archives
    convert_disk_image_virtual vmdk
    convert_disk_image_virtual vdi
    convert_disk_image_virtual qcow2

    convert_disk_image_zip vmdk
    convert_disk_image_zip vdi
    convert_disk_image_xz qcow2

    # Use unresized image for .img.xz
    mv "$hdd_img_orig" "$hdd_img"
    convert_disk_image_xz
}
