#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Need a version!"
    exit 1
fi

sed -i "s/UBOOT_CUSTOM_VERSION_VALUE=\".*\"/UBOOT_CUSTOM_VERSION_VALUE=\"$1\"/g" buildroot-external/configs/*
