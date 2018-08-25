#!/bin/bash

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local SPL_IMG="$(path_spl_img)"

    cp -t ${BOOT_DATA} \
        ${BINARIES_DIR}/boot.scr \
        ${BINARIES_DIR}/rk3288-tinker.dtb

    echo "console=tty1" > ${BOOT_DATA}/cmdline.txt

    # Create boot binary
    rm -f ${BINARIES_DIR}/u-boot-spl-dtb.img
    mkimage -n rk3288 -T rksd -d ${BINARIES_DIR}/u-boot-spl-dtb.bin ${BINARIES_DIR}/u-boot-spl-dtb.img
    cat ${BINARIES_DIR}/u-boot-dtb.bin >> ${BINARIES_DIR}/u-boot-spl-dtb.img

    # SPL
    create_spl_image

    dd if=${BINARIES_DIR}/u-boot-spl-dtb.img of=${SPL_IMG} conv=notrunc bs=512 seek=64
}


function hassos_post_image() {
    convert_disk_image_gz
}

