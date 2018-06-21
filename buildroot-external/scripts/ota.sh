#!/bin/bash

function create_ota_update() {
    local rauc_folder="${BINARIES_DIR}/rauc"
    
    rm -rf ${rauc_folder}
    mkdir -p ${rauc_folder}
}
