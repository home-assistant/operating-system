#!/bin/bash
# shellcheck disable=SC2155

function create_ota_update() {
    local ota_file="$(hassos_image_name raucb)"
    local rauc_folder="${BINARIES_DIR}/rauc"
    local boot="${BINARIES_DIR}/boot.vfat"
    local kernel="${BINARIES_DIR}/kernel.ext4"
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

    cp -f "${kernel}" "${rauc_folder}/kernel.ext4"
    cp -f "${boot}" "${rauc_folder}/boot.vfat"
    cp -f "${rootfs}" "${rauc_folder}/rootfs.img"
    cp -f "${BR2_EXTERNAL_HASSOS_PATH}/ota/rauc-hook" "${rauc_folder}/hook"

    (
        echo "[update]"
        echo "compatible=$(hassos_rauc_compatible)"
        echo "version=$(hassos_version)"
        echo "[hooks]"
        echo "filename=hook"
        echo "hooks=install-check"
        echo "[image.boot]"
        echo "filename=boot.vfat"
        echo "hooks=install"
        echo "[image.kernel]"
        echo "filename=kernel.ext4"
        echo "[image.rootfs]"
        echo "filename=rootfs.img"
    ) > "${rauc_folder}/manifest.raucm"

    # SPL
    if [ "${BOOT_SPL}" == "true" ]; then
        cp -f "${spl}" "${rauc_folder}/spl.img"

        (
            echo "[image.spl]"
            echo "filename=spl.img"
            echo "hooks=install"
        ) >> "${rauc_folder}/manifest.raucm"
    fi

    rauc bundle -d --cert="${cert}" --key="${key}" --keyring="${keyring}" "${rauc_folder}" "${ota_file}"
}
