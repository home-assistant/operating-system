#!/bin/bash

kernel_patches_with_version=$(find buildroot-external -type d -regextype sed -regex ".*/linux/[0-9\.]*")

if [ -n "$kernel_patches_with_version" ]; then
	echo ""
	echo "WARNING: Kernel patch directories with kernel version found! Check if updates are needed."
fi
