#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/u-boot.bin" \
        "${BINARIES_DIR}/boot.scr"
    cp -r "${BINARIES_DIR}/rpi-firmware/overlays" "${BOOT_DATA}/"
    cp "${BOARD_DIR}/../boot-env.txt" "${BOOT_DATA}/config.txt"

    # Firmware
    if [[ "${BOARD_ID}" =~ "rpi4" ]]; then
        cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/rpi-firmware/fixup4.dat" \
        "${BINARIES_DIR}/rpi-firmware/start4.elf"
    else
        cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/rpi-firmware/fixup.dat" \
        "${BINARIES_DIR}/rpi-firmware/start.elf" \
        "${BINARIES_DIR}/rpi-firmware/bootcode.bin"
    fi

    # DTS
    if [[ "${BOARD_ID}" == "rpi" ]]; then
        cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/rpi-firmware/bcm2708-rpi-b.dtb" \
        "${BINARIES_DIR}/rpi-firmware/bcm2708-rpi-b-plus.dtb" \
        "${BINARIES_DIR}/rpi-firmware/bcm2708-rpi-cm.dtb"
    elif [[ "${BOARD_ID}" == "rpi0-w" ]]; then
        cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/rpi-firmware/bcm2708-rpi-zero-w.dtb"
    elif [[ "${BOARD_ID}" == "rpi2" ]]; then
        cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/rpi-firmware/bcm2709-rpi-2-b.dtb" \
        "${BINARIES_DIR}/rpi-firmware/bcm2710-rpi-2-b.dtb"
    elif [[ "${BOARD_ID}" =~ "rpi3" ]]; then
        cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/rpi-firmware/bcm2710-rpi-3-b.dtb" \
        "${BINARIES_DIR}/rpi-firmware/bcm2710-rpi-3-b-plus.dtb" \
        "${BINARIES_DIR}/rpi-firmware/bcm2710-rpi-cm3.dtb"
    elif [[ "${BOARD_ID}" =~ "rpi4" ]]; then
        cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/rpi-firmware/bcm2711-rpi-4-b.dtb"
    fi

    # Set cmd options
    echo "dwc_otg.lpm_enable=0 console=tty1" > "${BOOT_DATA}/cmdline.txt"

    # Enable 64bit support
    if [[ "${BOARD_ID}" =~ "64" ]]; then
        sed -i "s|#arm_64bit|arm_64bit|g" "${BOOT_DATA}/config.txt"
    fi
}


function hassos_post_image() {
    convert_disk_image_gz
}

