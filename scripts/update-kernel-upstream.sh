#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Need a kernel version!"
    exit 1
fi

defconfigs=(buildroot-external/configs/{generic_x86_64,ova,tinker,odroid_c*,odroid_xu4}_defconfig)
sed -i "s/BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE=\".*\"/BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE=\"$1\"/g" "${defconfigs[@]}"
sed -i "s/| \(Open Virtual Appliance\|Generic x86-64\|Tinker Board\|Odroid-C.\|Odroid-XU4\) | .* |/| \1 | $1 |/g" Documentation/kernel.md
git commit -m "Linux: Update kernel $1" "${defconfigs[@]}" Documentation/kernel.md

./scripts/check-kernel-patches.sh
