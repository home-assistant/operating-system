#!/bin/bash

function fix_rootfs() {

    # Cleanup DHCP service, we don't need this with NetworkManager
    rm -rf ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/dhcpcd.service
    rm -rf ${TARGET_DIR}/usr/lib/systemd/system/dhcpcd.service
}
