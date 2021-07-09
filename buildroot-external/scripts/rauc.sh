#!/bin/bash
set -e

function _create_rauc_header() {
    (
        echo "[system]"
        echo "compatible=$(hassos_rauc_compatible)"
        echo "mountprefix=/run/rauc"
        echo "statusfile=/mnt/data/rauc.db"
        echo "bootloader=${BOOTLOADER}"

        echo "[keyring]"
        echo "path=/etc/rauc/keyring.pem"
    ) > "${TARGET_DIR}/etc/rauc/system.conf"
}


function _write_rauc_boot() {
    (
        echo "[slot.boot.0]"
        echo "device=/dev/disk/by-partlabel/hassos-boot"
        echo "type=vfat"
        echo "allow-mounted=true"
    ) >> "${TARGET_DIR}/etc/rauc/system.conf"

    # SPL
    if ! [ "${BOOT_SPL}" == "true" ]; then
        return 0
    fi

    (
        echo "[slot.spl.0]"
        echo "device=/dev/disk/by-partlabel/hassos-boot"
        echo "type=raw"
    ) >> "${TARGET_DIR}/etc/rauc/system.conf"
}


function _write_rauc_system() {
    local slot_num=${1}
    local slot_name=${2}

    (
        echo "[slot.kernel.${slot_num}]"
        echo "device=/dev/disk/by-partlabel/hassos-kernel${slot_num}"
        echo "type=raw"
        echo "bootname=${slot_name}"

        echo "[slot.rootfs.${slot_num}]"
        echo "device=/dev/disk/by-partlabel/hassos-system${slot_num}"
        echo "type=raw"
        echo "parent=kernel.${slot_num}"
    ) >> "${TARGET_DIR}/etc/rauc/system.conf"
}


function write_rauc_config() {
    mkdir -p "${TARGET_DIR}/etc/rauc"

    _create_rauc_header
    _write_rauc_boot
    _write_rauc_system 0 A
    _write_rauc_system 1 B
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
    else
        cp -f "${BR2_EXTERNAL_HASSOS_PATH}/bootloader/barebox-state-efi.dtb" "${TARGET_DIR}/etc/barebox-state.dtb"
    fi

    # Fix MBR
    if [ "${BOOT_SYS}" == "mbr" ]; then
        mkdir -p "${TARGET_DIR}/usr/lib/udev/rules.d"
	    cp -f "${BR2_EXTERNAL_HASSOS_PATH}/bootloader/mbr-part.rules" "${TARGET_DIR}/usr/lib/udev/rules.d/"
    fi
}
