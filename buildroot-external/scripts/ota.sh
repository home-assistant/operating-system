#!/bin/bash
# shellcheck disable=SC2155

function create_ota_update() {
    local ota_file="$(hassos_image_name raucb)"
    local ota_compatible="$(hassos_rauc_compatible)"
    local ota_version="$(hassos_version)"
    local rauc_folder="${BINARIES_DIR}/rauc"
    local boot="${BINARIES_DIR}/boot.vfat"
    local kernel="${BINARIES_DIR}/kernel.img"
    local rootfs="${BINARIES_DIR}/rootfs.squashfs"
    local spl="${BINARIES_DIR}/spl.img"
    local key="/build/key.pem"
    local cert="/build/cert.pem"
    local keyring="${TARGET_DIR}/etc/rauc/keyring.pem"

    # Skip if no dev key is arround
    if [ ! -f "${key}" ]; then
        echo "Skip creating OTA update because of missing key ${key}"
        return 0
    fi

    rm -rf "${rauc_folder}" "${ota_file}"
    mkdir -p "${rauc_folder}"

    cp -f "${kernel}" "${rauc_folder}/kernel.img"
    cp -f "${boot}" "${rauc_folder}/boot.vfat"
    cp -f "${rootfs}" "${rauc_folder}/rootfs.img"
    cp -f "${BR2_EXTERNAL_HASSOS_PATH}/ota/rauc-hook" "${rauc_folder}/hook"

    # SPL
    if [ "${BOOT_SPL}" == "true" ]; then
        cp -f "${spl}" "${rauc_folder}/spl.img"
    fi

    export BOOTLOADER BOOT_SPL
    export ota_compatible ota_version
    (
        "${HOST_DIR}/bin/tempio" \
            -template "${BR2_EXTERNAL_HASSOS_PATH}/ota/manifest.raucm.gtpl"
    ) > "${rauc_folder}/manifest.raucm"

    rauc bundle -d --cert="${cert}" --key="${key}" --keyring="${keyring}" "${rauc_folder}" "${ota_file}"
}
