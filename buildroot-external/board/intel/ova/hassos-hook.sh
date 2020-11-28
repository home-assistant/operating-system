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
    local HDD_IMG="$(hassos_image_name img)"
    local HDD_OVA="$(hassos_image_name ova)"
    local OVA_DATA="${BINARIES_DIR}/ova"

    # Virtual Disk images
    convert_disk_image_virtual

    convert_disk_image_xz vmdk
    convert_disk_image_xz vhdx
    convert_disk_image_xz vdi
    convert_disk_image_xz qcow2

    # OVA
    mkdir -p "${OVA_DATA}"
    rm -f "${HDD_OVA}"

    cp -a "${BOARD_DIR}/home-assistant.ovf" "${OVA_DATA}/home-assistant.ovf"
    qemu-img convert -O vmdk -o subformat=streamOptimized "${HDD_IMG}" "${OVA_DATA}/home-assistant.vmdk"
    (cd "${OVA_DATA}" || exit 1; sha256sum --tag home-assistant.* >home-assistant.mf)
    tar -C "${OVA_DATA}" --owner=root --group=root -cf "${HDD_OVA}" home-assistant.ovf home-assistant.vmdk home-assistant.mf

    # Cleanup
    rm -f "${HDD_IMG}"
}
