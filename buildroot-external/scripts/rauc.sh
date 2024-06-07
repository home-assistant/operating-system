#!/bin/bash
set -e


function prepare_rauc_signing() {
    local key="/build/key.pem"
    local cert="/build/cert.pem"

    if [ ! -f "${key}" ]; then
        echo "Generating a self-signed certificate for development"
        "${BR2_EXTERNAL_HASSOS_PATH}"/scripts/generate-signing-key.sh "${cert}" "${key}"
    fi
}


function write_rauc_config() {
    mkdir -p "${TARGET_DIR}/etc/rauc"

    local ota_compatible
    ota_compatible="$(hassos_rauc_compatible)"

    export ota_compatible
    export BOOTLOADER PARTITION_TABLE_TYPE BOOT_SPL

    (
        "${HOST_DIR}/bin/tempio" \
            -template "${BR2_EXTERNAL_HASSOS_PATH}/ota/system.conf.gtpl"
    ) > "${TARGET_DIR}/etc/rauc/system.conf"
}


function install_rauc_certs() {
    local cert="/build/cert.pem"

    if [ "${DEPLOYMENT}" == "development" ]; then
        # Contains development and release certificate
        cp "${BR2_EXTERNAL_HASSOS_PATH}/ota/dev-ca.pem" "${TARGET_DIR}/etc/rauc/keyring.pem"
    else
        cp "${BR2_EXTERNAL_HASSOS_PATH}/ota/rel-ca.pem" "${TARGET_DIR}/etc/rauc/keyring.pem"
    fi

    # Add local self-signed certificate (if not trusted by the dev or release
    # certificate it is a self-signed certificate, dev-ca.pem contains both)
    if ! openssl verify -CAfile "${BR2_EXTERNAL_HASSOS_PATH}/ota/dev-ca.pem" -no-CApath "${cert}"; then
        echo "Adding self-signed certificate to keyring."
        openssl x509 -in "${cert}" -text >> "${TARGET_DIR}/etc/rauc/keyring.pem"
    fi
}


function install_bootloader_config() {
    if [ "${BOOTLOADER}" == "uboot" ]; then
        # shellcheck disable=SC1117
        echo -e "/dev/disk/by-partlabel/hassos-bootstate\t0x0000\t${BOOT_ENV_SIZE}" > "${TARGET_DIR}/etc/fw_env.config"
    fi

    # Fix MBR
    if [ "${PARTITION_TABLE_TYPE}" == "mbr" ]; then
        mkdir -p "${TARGET_DIR}/usr/lib/udev/rules.d"
        cp -f "${BR2_EXTERNAL_HASSOS_PATH}/bootloader/mbr-part.rules" "${TARGET_DIR}/usr/lib/udev/rules.d/"
    fi
}
