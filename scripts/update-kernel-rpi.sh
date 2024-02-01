#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Need a commit ID!"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Need a kernel version!"
    exit 1
fi

defconfigs=(buildroot-external/configs/{rpi*,yellow}_defconfig)
sed -i "s|BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION=\"https://github.com/raspberrypi/linux/.*\"|BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION=\"https://github.com/raspberrypi/linux/archive/$1.tar.gz\"|g" "${defconfigs[@]}"
sed -i "s/| \(Raspberry Pi.*\|Home Assistant Yellow\) | .* |/| \1 | $2 |/g" Documentation/kernel.md
git commit -m "RaspberryPi: Update kernel to $2 - $1" "${defconfigs[@]}" Documentation/kernel.md

./scripts/check-kernel-patches.sh

echo
echo "WARNING: bumping RPi kernel usually requires bump of rpi-firmware"
echo "package to version from the corresponding branch in raspberrypi/firmware"
echo "repository (which is usually the stable branch), namely because the DT"
echo "overlays are copied from this repository"
