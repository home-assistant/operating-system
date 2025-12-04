#!/bin/bash
#
# Hook executed by hassos build scripts (post/pre image) to install boot files.
# Place tested boot artifacts in board/orangepi4/boot/:
#  - idbloader.img (Rockchip SPL)
#  - u-boot.itb or u-boot.img
#  - Image or Image.gz
#  - ${DTB_NAME}
#
# If you prefer automatic download in CI, implement fetch logic here (curl/wget)
# using KERNEL_TARBALL_URL and UBOOT_TARBALL_URL variables from meta.

function hassos_pre_image() {
    echo "orangepi4: installing boot files"
    BOOTDIR="$(path_boot_dir)"
    mkdir -p "${BOOTDIR}"

    # Copy any prepared boot files from board dir
    if [ -d "${BOARD_DIR}/boot" ]; then
        cp -a "${BOARD_DIR}/boot/." "${BOOTDIR}/" || true
    fi

    # If DTB_NAME variable exists in meta, try copying named dtb if present
    if [ -n "${DTB_NAME}" ] && [ -f "${BOARD_DIR}/boot/${DTB_NAME}" ]; then
        cp "${BOARD_DIR}/boot/${DTB_NAME}" "${BOOTDIR}/"
    fi

    echo "orangepi4: boot files installed to ${BOOTDIR}"
}

function hassos_post_image() {
    true
}
