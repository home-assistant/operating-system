#!/bin/bash

function fix_rootfs() {

    # Cleanup DHCP service, we don't need this with NetworkManager
    rm -rf ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/dhcpcd.service
    rm -rf ${TARGET_DIR}/usr/lib/systemd/system/dhcpcd.service

    # Cleanup etc
    rm -rf ${TARGET_DIR}/etc/init.d
    rm -rf ${TARGET_DIR}/etc/network
    rm -rf ${TARGET_DIR}/etc/X11
    rm -rf ${TARGET_DIR}/etc/xdg

    # Cleanup root
    rm -rf ${TARGET_DIR}/media
    rm -rf ${TARGET_DIR}/srv
    rm -rf ${TARGET_DIR}/opt

    # Fix: tempfs with /srv
    sed -i "/srv/d" ${TARGET_DIR}/usr/lib/tmpfiles.d/home.conf

    # Fix: Could not generate persistent MAC address
    sed -i "s/MACAddressPolicy=persistent/MACAddressPolicy=none/g" ${TARGET_DIR}/usr/lib/systemd/network/99-default.link
}


function install_hassos_cli() {

    sed -i "s|\(root.*\)/bin/sh|\1/usr/sbin/hassos-cli|" ${TARGET_DIR}/etc/passwd
}
