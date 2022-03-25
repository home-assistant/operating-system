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

    # systemd-update-done.service relies on writeable /var and /etc
    rm -f "${TARGET_DIR}/usr/lib/systemd/system/sysinit.target.wants/systemd-update-done.service"

    # Fix: tempfs with /srv
    sed -i "/srv/d" "${TARGET_DIR}/usr/lib/tmpfiles.d/home.conf"

    # Fix: Could not generate persistent MAC address
    sed -i "s/MACAddressPolicy=persistent/MACAddressPolicy=none/g" "${TARGET_DIR}/usr/lib/systemd/network/99-default.link"

    # Use systemd-resolved for Host OS resolve
    sed -i '/^hosts:/ {/resolve/! s/files/resolve [!UNAVAIL=return] files/}' "${TARGET_DIR}/etc/nsswitch.conf"

    # Remove e2scrub (LVM specific tools provided by e2fsprogs)
    rm -f "/usr/lib/systemd/system/e2scrub*"
    rm -f "/usr/sbin/e2scrub*" "/usr/lib/e2fsprogs/e2scrub*"
}


function install_tini_docker() {
    ln -fs /usr/bin/tini "${TARGET_DIR}/usr/bin/docker-init"
}
