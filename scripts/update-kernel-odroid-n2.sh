#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Need a kernel version!"
    exit 1
fi

defconfigs=(buildroot-external/configs/odroid_n2_defconfig)
sed -i "s/BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE=\".*\"/BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE=\"$1\"/g" "${defconfigs[@]}"
sed -i "s/| \(Odroid-N2\) | .* |/| \1 | $1 |/g" Documentation/kernel.md
git commit -m "Linux: Update kernel $1" "${defconfigs[@]}" Documentation/kernel.md

kernel_patches_with_version=$(find buildroot-external -type d -regextype sed -regex ".*/linux/[0-9\.]*")

if [ -n "$kernel_patches_with_version" ]; then
	echo ""
	echo "WARNING: Kernel patch directories with kernel version found! Check if updates are needed."
fi
