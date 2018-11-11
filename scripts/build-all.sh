#!/bin/bash
set -e

mkdir -p /build/release

all_platforms=(odroid_c2)
for platform in "${all_platforms[@]}"; do
    make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external \
        ${platform}_defconfig
    make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external
    cp -f /build/buildroot/output/images/hassos_* /build/release/

    make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external \
        clean
done
