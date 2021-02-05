#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Need a commit ID!"
    exit 1
fi
echo "Use firmware: https://github.com/raspberrypi/firmware/archive/$1.tar.gz"

if [ -z "$2" ] || ! [ -f "$2" ]; then
    echo "Need buildroot patch file!"
    exit 1
fi

patch -Rf -d buildroot -p 1 < "$2"

rm -rf /tmp/rpi-firmware.tar.gz
curl -Lo /tmp/rpi-firmware.tar.gz "https://github.com/raspberrypi/firmware/archive/$1.tar.gz"
checksum="$(sha256sum /tmp/rpi-firmware.tar.gz | cut -d' ' -f 1)"
rm -rf /tmp/rpi-firmware.tar.gz


sed -i "s/+RPI_FIRMWARE_VERSION = [a-f0-9]*/+RPI_FIRMWARE_VERSION = $1/g" "$2"
sed -i "s/+sha256\s*[a-f0-9]*\s*rpi-firmware-[a-f0-9]*.tar.gz/+sha256  $checksum  rpi-firmware-$1.tar.gz/g" "$2"

patch -d buildroot -p 1 < "$2"
git commit -m "RaspberryPi: Update firmware $1" "$2" buildroot/package/rpi-firmware
