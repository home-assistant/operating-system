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


function prune_unused_firmware() {
    # Remove firmware which the kernel drivers never load. The per-driver logic
    # depends on how each driver requests its firmware and has been verified
    # for the kernel versions below only.
    local validated_kernels=("6.18")
    local kernel_dirs kernel declared_firmware

    kernel_dirs=("${TARGET_DIR}"/usr/lib/modules/*/)
    kernel=$(basename "${kernel_dirs[0]}")
    if [ "${#kernel_dirs[@]}" -ne 1 ] || ! [[ "${kernel}" =~ ^([0-9]+\.[0-9]+)\. ]]; then
        echo "ERROR: Cannot determine kernel version for firmware pruning" >&2
        return 1
    fi
    if [[ " ${validated_kernels[*]} " != *" ${BASH_REMATCH[1]} "* ]]; then
        echo "ERROR: Firmware pruning was validated for Linux ${validated_kernels[*]}, but the kernel" \
             "is ${kernel}. Check that the prune_firmware_* functions still match how the drivers" \
             "load their firmware, then add it to validated_kernels in ${BASH_SOURCE[0]}." >&2
        return 1
    fi

    if ! [ -f "${kernel_dirs[0]}/modules.builtin.modinfo" ]; then
        echo "ERROR: Missing modules.builtin.modinfo in ${kernel_dirs[0]}" >&2
        return 1
    fi

    # Firmware declared by the drivers via MODULE_FIRMWARE()
    if ! declared_firmware=$(
        set -o pipefail
        find "${kernel_dirs[0]}" \( -name "*.ko" -o -name "modules.builtin.modinfo" \) -exec cat {} + \
            | tr '\0' '\n' | sed -n 's/^\([[:alnum:]_-]*\.\)\{0,1\}firmware=//p' | sort -u
    ); then
        echo "ERROR: Cannot read firmware declared by kernel modules" >&2
        return 1
    fi

    prune_firmware_rtw89 "${declared_firmware}"
}


function prune_firmware_rtw89() {
    # rtw89 requests rtw89/<chip>_fw[-N].bin, counting N down from the format
    # declared by MODULE_FIRMWARE() and using the first file found. Keep only
    # that file for each chip; firmware of chips not built at all is removed.
    local declared_firmware="${1}"
    local fw_dir="${TARGET_DIR}/usr/lib/firmware/rtw89"
    local pattern="^(.+_fw)(-([0-9]+))?\.bin$"
    local -A max_ver best_ver
    local name base ver file

    [ -d "${fw_dir}" ] || return 0

    while read -r name; do
        [[ "${name}" == "rtw89/"* ]] || continue
        [[ "${name#rtw89/}" =~ ${pattern} ]] || continue
        base="${BASH_REMATCH[1]}"
        ver="${BASH_REMATCH[3]:-0}"
        if [ "${ver}" -gt "${max_ver[${base}]:--1}" ]; then
            max_ver[${base}]="${ver}"
        fi
    done <<< "${declared_firmware}"

    for file in "${fw_dir}"/*; do
        [[ "$(basename "${file}")" =~ ${pattern} ]] || continue
        base="${BASH_REMATCH[1]}"
        ver="${BASH_REMATCH[3]:-0}"
        [ -n "${max_ver[${base}]}" ] && [ "${ver}" -le "${max_ver[${base}]}" ] || continue
        if [ "${ver}" -gt "${best_ver[${base}]:--1}" ]; then
            best_ver[${base}]="${ver}"
        fi
    done

    for file in "${fw_dir}"/*; do
        [[ "$(basename "${file}")" =~ ${pattern} ]] || continue
        base="${BASH_REMATCH[1]}"
        ver="${BASH_REMATCH[3]:-0}"
        if [ "${ver}" != "${best_ver[${base}]}" ]; then
            echo "Removing unused firmware rtw89/$(basename "${file}")"
            rm -f "${file}"
        fi
    done
}


function install_tini_docker() {
    ln -fs /usr/bin/tini "${TARGET_DIR}/usr/bin/docker-init"
}

function setup_localtime() {
    # localtime is writable through SYSTEMD_ETC_LOCALTIME
    ln -fs /mnt/overlay/etc/localtime "${TARGET_DIR}/etc/localtime"
}

function setup_vconsole() {
    # vconsole.conf is writable through SYSTEMD_ETC_VCONSOLE_CONF
    ln -fs /mnt/overlay/etc/vconsole.conf "${TARGET_DIR}/etc/vconsole.conf"
}
