#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Need a kernel version!"
    exit 1
fi

sed -i "s/BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE=\".*\"/BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE=\"$1\"/g" buildroot-external/configs/{generic_x86,ova,tinker,odroid*}_defconfig
sed -i "s/| \(Open Virtual Appliance\|Generic x86-64\|Tinker Board\|Odroid-.*\) | .* |/| \1 | $1 |/g" Documentation/kernel.md
git commit -m "Linux: Update kernel $1" buildroot-external/configs/* Documentation/kernel.md
