#!/bin/bash

function create_ota_update() {
    local ota_file="$(hassos_image_name raucb)"
    local rauc_folder="${BINARIES_DIR}/rauc"
    local boot_folder="${BINARIES_DIR}/boot"
    local kernel="${BINARIES_DIR}/${KERNEL_FILE}"
    local rootfs="${BINARIES_DIR}/rootfs.squashfs"
    local key="/build/key.pem"
    local cert="/build/cert.pem"

    rm -rf ${rauc_folder} ${ota_file}
    mkdir -p ${rauc_folder}

    tar -P -cf ${rauc_folder}/kernel.tar ${kernel}
    tar -P -cf ${rauc_folder}/boot.tar ${boot_folder}
    cp -f ${rootfs} ${rauc_folder}/rootfs.img

    (
        echo "[update]"
        echo "compatible=$(hassos_rauc_compatible)"
        echo "version=$(hassos_version)"
        echo "[image.boot]"
        echo "filename=boot.tar"
        echo "[image.kernel]"
        echo "filename=kernel.tar"
        echo "[image.rootfs]"
        echo "filename=rootfs.img"
    ) > ${rauc_folder}/manifest.raucm

    rauc bundle -d --cert=${cert} --key=${key} ${rauc_folder} ${ota_file}
}
