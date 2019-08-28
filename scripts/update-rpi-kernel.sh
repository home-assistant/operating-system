#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Need a version!"
    exit 1
fi

sed -i "s/BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION=\".*\"/BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION=\"$1\"/g" buildroot-external/configs/rpi*
git commit -m "RaspberryPi: Update kernel $1" buildroot-external/configs/*
