#!/bin/bash

function create_ota_update() {
    local rauc_folder="${BINARIES_DIR}/rauc"
    local boot_folder="${BINARIES_DIR}/boot"
    local kernel="${BINARIES_DIR}/${2}"
    local rootfs="${BINARIES_DIR}/rootfs.squash"
    
    rm -rf ${rauc_folder}
    mkdir -p ${rauc_folder}
    
    tar -pcf ${rauc_folder}/kernel.tar ${kernel}
    tar -pcf ${rauc_folder}/boot.tar ${boot_folder}
    cp -f ${rootfs} ${rauc_folder}/rootfs.img
}
