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

    # Remove info pages
    rm -rf "${TARGET_DIR:?}/share/info"
    rm -rf "${TARGET_DIR:?}/usr/share/info"

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

    # Remove unnecessary grub userspace tools, config, modules and translations
    find "${TARGET_DIR}"/usr/{,s}bin -name "grub-*" -not -name "grub-editenv" -delete
    rm -rf "${TARGET_DIR}/etc/grub.d"
    rm -rf "${TARGET_DIR}/usr/lib/grub"
    if [ -d "${TARGET_DIR}/share/locale" ]; then
        find "${TARGET_DIR}/share/locale" -name "grub.mo" -delete
        find "${TARGET_DIR}/share/locale" -type d -empty -delete
    fi
}


function install_tini_docker() {
    ln -fs /usr/bin/tini "${TARGET_DIR}/usr/bin/docker-init"
}
