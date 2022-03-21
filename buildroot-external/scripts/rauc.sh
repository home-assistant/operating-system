#!/bin/bash
set -e


function write_rauc_config() {
    mkdir -p "${TARGET_DIR}/etc/rauc"

    local ota_compatible
    ota_compatible="$(hassos_rauc_compatible)"

    export ota_compatible
    export BOOTLOADER BOOT_SYS BOOT_SPL

    (
        "${HOST_DIR}/bin/tempio" \
            -template "${BR2_EXTERNAL_HASSOS_PATH}/ota/system.conf.gtpl"
    ) > "${TARGET_DIR}/etc/rauc/system.conf"
}


function install_rauc_certs() {
    if [ "${DEPLOYMENT}" == "production" ]; then
        cp "${BR2_EXTERNAL_HASSOS_PATH}/ota/rel-ca.pem" "${TARGET_DIR}/etc/rauc/keyring.pem"
    else
        cp "${BR2_EXTERNAL_HASSOS_PATH}/ota/dev-ca.pem" "${TARGET_DIR}/etc/rauc/keyring.pem"
    fi
}


function install_bootloader_config() {
    if [ "${BOOTLOADER}" == "uboot" ]; then
    	# shellcheck disable=SC1117
        echo -e "/dev/disk/by-partlabel/hassos-bootstate\t0x0000\t${BOOT_ENV_SIZE}" > "${TARGET_DIR}/etc/fw_env.config"
    fi

    # Fix MBR
    if [ "${BOOT_SYS}" == "mbr" ]; then
        mkdir -p "${TARGET_DIR}/usr/lib/udev/rules.d"
	    cp -f "${BR2_EXTERNAL_HASSOS_PATH}/bootloader/mbr-part.rules" "${TARGET_DIR}/usr/lib/udev/rules.d/"
    fi
}
