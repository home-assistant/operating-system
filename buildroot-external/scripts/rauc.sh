#!/bin/bash
set -e

function _create_rauc_header() {
    (
        echo "[system]"
	echo "compatible=$(hassos_rauc_compatible)"
        echo "mountprefix=/run/rauc"
        echo "statusfile=/mnt/data/rauc.db"
        echo "bootloader=${BOOTLOADER}"

        echo "[handlers]"
        echo "pre-install=/usr/lib/rauc/pre-install"
        echo "post-install=/usr/lib/rauc/post-install"

        echo "[keyring]"
        echo "path=/etc/rauc/keyring.pem"
    ) > ${TARGET_DIR}/etc/rauc/system.conf
}


function _write_rauc_boot() {
    local boot_device=${1}
    (
        echo "[slot.boot.0]"
        echo "device=${boot_device}"
        echo "type=vfat"
    ) >> ${TARGET_DIR}/etc/rauc/system.conf

    if [ "${BOOT_SYS}" != "spl" ]; then
        return 0
    fi

    (
        echo "[slot.spl.0]"
        echo "device=${boot_device}"
        echo "type=raw"
    ) >> ${TARGET_DIR}/etc/rauc/system.conf
}


function _write_rauc_system() {
    local kernel_device=${1}
    local system_device=${2}
    local slot_num=${3}
    local slot_name=${4}

    (
        echo "[slot.kernel.${slot_num}]"
        echo "device=${kernel_device}"
        echo "type=ext4"
        echo "bootname=${slot_name}"

        echo "[slot.rootfs.${slot_num}]"
        echo "device=${system_device}"
        echo "type=raw"
        echo "parent=kernel.${slot_num}"
    ) >> ${TARGET_DIR}/etc/rauc/system.conf
}


function write_rauc_config() {
    local boot_d="${PART_BOOT:-/dev/disk/by-partlabel/hassos-boot}"
    local kernel_d0="${PART_KERNEL_0:-/dev/disk/by-partlabel/hassos-kernel0}"
    local system_d0="${PART_SYSTEM_0:-/dev/disk/by-partlabel/hassos-system0}"
    local kernel_d1="${PART_KERNEL_1:-/dev/disk/by-partlabel/hassos-kernel1}"
    local system_d1="${PART_SYSTEM_1:-/dev/disk/by-partlabel/hassos-system1}"

    mkdir -p ${TARGET_DIR}/etc/rauc

    _create_rauc_header
    _write_rauc_boot "${boot_d}"
    _write_rauc_system "${kernel_d0}" "${system_d0}" 0 A
    _write_rauc_system "${kernel_d1}" "${system_d1}" 1 B
}


function install_rauc_certs() {
    if [ "${DEPLOYMENT}" == "production" ]; then
        cp ${BR2_EXTERNAL_HASSOS_PATH}/misc/rel-ca.pem ${TARGET_DIR}/etc/rauc/keyring.pem
    else
        cp ${BR2_EXTERNAL_HASSOS_PATH}/misc/dev-ca.pem ${TARGET_DIR}/etc/rauc/keyring.pem
    fi
}


function install_bootloader_config() {
    local boot_env="${BOOT_ENV:-/dev/disk/by-partlabel/hassos-bootstate}"
    local boot_env_off="${BOOT_ENV_OFF:-0x0000}"
    if [ "${BOOTLOADER}" == "uboot" ]; then
        echo -e "${boot_env}\t${boot_env_off}\t${BOOT_ENV_SIZE}" > ${TARGET_DIR}/etc/fw_env.config
    else
        cp ${BR2_EXTERNAL_HASSOS_PATH}/misc/barebox-state-efi.dtb ${TARGET_DIR}/etc/barebox-state.dtb
    fi
}
