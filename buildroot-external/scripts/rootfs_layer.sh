#!/bin/bash

function fix_rootfs() {

    # Cleanup DHCP service, we don't need this with NetworkManager
    rm -rf ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/dhcpcd.service
    rm -rf ${TARGET_DIR}/usr/lib/systemd/system/dhcpcd.service

    # Cleanup etc
    rm -rf ${TARGET_DIR}/etc/init.d
    rm -rf ${TARGET_DIR}/etc/modules-load.d
    rm -rf ${TARGET_DIR}/etc/network
    rm -rf ${TARGET_DIR}/etc/X11
    rm -rf ${TARGET_DIR}/etc/xdg

    # Cleanup root
    rm -rf ${TARGET_DIR}/media
    rm -rf ${TARGET_DIR}/srv
    rm -rf ${TARGET_DIR}/opt

    # Fix tempfs
    sed -i "/srv/d" ${TARGET_DIR}/usr/lib/tmpfiles.d/home.conf
}


function install_hassio_cli() {

    sed -i "s|\(root.*\)/bin/sh|\1/usr/sbin/hassio-cli|" ${TARGET_DIR}/etc/passwd
}
