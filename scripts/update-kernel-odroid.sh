#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Need a kernel version!"
    exit 1
fi

sed -i "s/BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE=\".*\"/BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE=\"$1\"/g" buildroot-external/configs/odroid_*
sed -i "s/| Odroid\(.*\) | .* |/| Odroid\1 | $1 |/g" Documentation/kernel.md
git commit -m "Odroid: Update kernel $1" buildroot-external/configs/* Documentation/kernel.md
