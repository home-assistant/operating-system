#!/bin/bash

function fix_rootfs() {

    # Cleanup etc
    rm -rf "${TARGET_DIR:?}/etc/init.d"
    rm -rf "${TARGET_DIR:?}/etc/network"
    rm -rf "${TARGET_DIR:?}/etc/X11"
    rm -rf "${TARGET_DIR:?}/etc/xdg"

    # Cleanup root
    rm -rf "${TARGET_DIR:?}/media"
    rm -rf "${TARGET_DIR:?}/srv"
    rm -rf "${TARGET_DIR:?}/opt"

    # Cleanup miscs
    rm -rf "${TARGET_DIR}/usr/lib/modules-load.d"

    # Fix: permission for system connection files
    chmod 600 "${TARGET_DIR}/etc/NetworkManager/system-connections"/*

    # Fix: tempfs with /srv
    sed -i "/srv/d" "${TARGET_DIR}/usr/lib/tmpfiles.d/home.conf"

    # Fix: Could not generate persistent MAC address
    sed -i "s/MACAddressPolicy=persistent/MACAddressPolicy=none/g" "${TARGET_DIR}/usr/lib/systemd/network/99-default.link"
}


function install_hassos_cli() {

    # shellcheck disable=SC1117
    sed -i "s|\(root:.*\)/bin/sh|\1/usr/sbin/hassos-cli|" "${TARGET_DIR}/etc/passwd"
    
    if ! grep "hassos-cli" "${TARGET_DIR}/etc/shells"; then
        echo "/usr/sbin/hassos-cli" >> "${TARGET_DIR}/etc/shells"
    fi
}


function install_tini_docker() {
    ln -fs /usr/bin/tini "${TARGET_DIR}/usr/bin/docker-init"
}
