#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/u-boot.bin" \
        "${BINARIES_DIR}/boot.scr"
    cp "${BINARIES_DIR}"/*.dtb "${BOOT_DATA}/"
    cp -r "${BINARIES_DIR}/rpi-firmware/"* "${BOOT_DATA}/"
    cp "${BOARD_DIR}/../boot-env.txt" "${BOOT_DATA}/config.txt"

    # EEPROM update for Raspberry Pi 4/Compute Module 4
    if grep -Eq "^BR2_PACKAGE_RPI_EEPROM=y$" "${BR2_CONFIG}"; then
        cp "${BINARIES_DIR}/rpi-eeprom/pieeprom.sig" "${BOOT_DATA}/pieeprom.sig"
        cp "${BINARIES_DIR}/rpi-eeprom/pieeprom.upd" "${BOOT_DATA}/pieeprom.upd"
    fi

    # Set cmd options
    echo "dwc_otg.lpm_enable=0 console=tty1" > "${BOOT_DATA}/cmdline.txt"

    # Enable 64bit support
    if [[ "${BOARD_ID}" =~ "64" ]]; then
        sed -i "s|#arm_64bit|arm_64bit|g" "${BOOT_DATA}/config.txt"
    fi
}


function hassos_post_image() {
    convert_disk_image_xz
}

