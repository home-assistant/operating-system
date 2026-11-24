#!/bin/bash
# Check that defconfigs match the output of "make savedefconfig".
# Usage: scripts/check-defconfigs.sh [defconfig...]

set -euo pipefail

cd "$(dirname "$0")/.."

if [ $# -eq 0 ]; then
    set -- buildroot-external/configs/*_defconfig
fi

out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT

report() {
    local file=$1 line=$2 message=$3
    if [ -n "${GITHUB_ACTIONS:-}" ]; then
        echo "::error file=${file},line=${line},title=Defconfig not in savedefconfig form::${message}"
    else
        echo "${file}:${line}: ${message}"
    fi
}

br_make() {
    if ! make -s -C buildroot O="$out/br" BR2_EXTERNAL="$PWD/buildroot-external" "$@" > "$out/make.log" 2>&1; then
        cat "$out/make.log" >&2
        exit 2
    fi
}

rc=0
for cfg in "$@"; do
    saved="$out/saved"
    failed=0
    echo "Checking ${cfg}"
    br_make BR2_DEFCONFIG="$(realpath "$cfg")" defconfig
    br_make BR2_DEFCONFIG="$saved" savedefconfig

    # The loops below read newline-terminated records, so terminate the last line
    current="$out/current"
    cp "$cfg" "$current"
    if [ -n "$(tail -c1 "$cfg")" ]; then
        failed=1
        report "$cfg" "$(grep -c '' "$cfg")" "Newline at the end of the file is missing"
        echo >> "$current"
    fi

    # Lines of the defconfig that savedefconfig moved or dropped
    while IFS=: read -r line text; do
        failed=1
        if [ -z "$text" ]; then
            report "$cfg" "$line" "Blank line is dropped by savedefconfig"
        elif target=$(grep -nFx -m1 -- "$text" "$saved"); then
            target=${target%%:*}
            if [ "$target" -gt 1 ]; then
                report "$cfg" "$line" "${text} is out of order, it belongs after $(sed -n "$((target - 1))p" "$saved")"
            else
                report "$cfg" "$line" "${text} is out of order, it belongs on the first line"
            fi
        else
            report "$cfg" "$line" "${text} is dropped by savedefconfig, the value is the default or the symbol is unknown"
        fi
    done < <(diff --old-line-format='%dn:%L' --new-line-format='' --unchanged-line-format='' "$current" "$saved" || true)

    # Lines that savedefconfig added
    while IFS= read -r text; do
        if ! grep -qFx -- "$text" "$cfg"; then
            failed=1
            report "$cfg" 1 "${text} is missing, savedefconfig adds it"
        fi
    done < <(diff --old-line-format='' --new-line-format='%L' --unchanged-line-format='' "$current" "$saved" || true)

    if [ "$failed" -eq 0 ]; then
        echo "  OK"
    else
        rc=1
    fi
done

if [ "$rc" -ne 0 ]; then
    echo "Regenerate the defconfig with \"make savedefconfig\" to fix the reported lines."
fi
exit "$rc"
