#!/bin/bash
set -e

mkdir -p /build/RL

all_platforms=(ova rpi rpi0_w rpi2 rpi3 rpi3_64)
for platform in "${all_platforms[@]}"; do
    make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external \
        ${platform}_defconfig
    make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external
    cp -f /build/buildroot/output/images/hassos_* /build/release/

    make -C /build/buildroot BR2_EXTERNAL=/build/buildroot-external \
        clean
done
