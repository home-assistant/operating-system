#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local EFIPART_DATA="${BINARIES_DIR}/efi-part"

    mkdir -p "${BOOT_DATA}/EFI/BOOT"

    cp "${BOARD_DIR}/../grub.cfg" "${EFIPART_DATA}/EFI/BOOT/grub.cfg"
    cp "${BOARD_DIR}/cmdline.txt" "${EFIPART_DATA}/cmdline.txt"
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" create
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" set ORDER="A B"
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" set A_OK=1
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" set A_TRY=0

    cp -r "${EFIPART_DATA}/"* "${BOOT_DATA}/"
}


function hassos_post_image() {
    local hdd_img="$(hassos_image_name img)"

    # Virtual Disk images
    convert_disk_image_virtual vmdk
    convert_disk_image_virtual vhdx
    convert_disk_image_virtual vdi
    convert_disk_image_virtual qcow2

    convert_disk_image_zip vmdk
    convert_disk_image_zip vhdx
    convert_disk_image_zip vdi
    convert_disk_image_xz qcow2

    # OVA
    convert_disk_image_ova

    # Cleanup
    rm -f "${hdd_img}"
}
