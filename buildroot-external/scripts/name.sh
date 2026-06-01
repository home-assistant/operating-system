#!/bin/bash

function haos_image_name() {
    echo "${BINARIES_DIR}/${HAOS_ID}_${BOARD_ID}-$(haos_version).${1}"
}

function haos_image_basename() {
    echo "${BINARIES_DIR}/${HAOS_ID}_${BOARD_ID}-$(haos_version)"
}

function haos_rauc_compatible() {
    echo "${HAOS_ID}-${BOARD_ID}"
}

function haos_version() {
    if [ -z "${VERSION_SUFFIX}" ]; then
        echo "${VERSION_MAJOR}.${VERSION_MINOR}"
    else
        echo "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_SUFFIX}"
    fi
}

function path_boot_dir() {
    echo "${BINARIES_DIR}/boot"
}

function path_data_img() {
    echo "${BINARIES_DIR}/data.ext4"
}

function path_rootfs_img() {
    echo "${BINARIES_DIR}/rootfs.erofs"
}
