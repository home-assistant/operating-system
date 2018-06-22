#!/bin/bash

function create_ota_update() {
    local ota_file="${1}"
    local rauc_folder="${BINARIES_DIR}/rauc"
    local boot_folder="${BINARIES_DIR}/boot"
    local kernel="${BINARIES_DIR}/${2}"
    local rootfs="${BINARIES_DIR}/rootfs.squash"
    local key="/build/secure/key.pem"
    local cert="/build/secure/cert.pem"

    rm -rf ${rauc_folder}
    mkdir -p ${rauc_folder}

    tar -pcf ${rauc_folder}/kernel.tar ${kernel}
    tar -pcf ${rauc_folder}/boot.tar ${boot_folder}
    cp -f ${rootfs} ${rauc_folder}/rootfs.img

    (
        echo "[update]"
        echo "compatible="
        echo "version="
        echo "[image.boot]"
        echo "filename=boot.tar"
        echo "[image.kernel]"
        echo "filename=kernel.tar"
        echo "[image.rootfs]"
        echo "filename=rootfs.img"
    ) > ${rauc_folder}/manifest.raucm

    rauc bundle --cert=${cert} --key=${key} ${rauc_folder} ${ota_file}
}
