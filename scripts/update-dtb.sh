#!/bin/sh

## OVA
dtc -@ -I dts -O dtb -o fdt/barebox-state-efi.dtb fdt/barebox-state-efi.dts
cp -f fdt/barebox-state-efi.dtb buildroot-external/board/ova/

## Raspberry
dtc -@ -I dts -O dtb -o fdt/barebox-state-rpi.dtbo fdt/barebox-state-rpi.dtso
cp -f fdt/barebox-state-rpi.dtbo  buildroot-external/board/rpi2/barebox-env/overlay/

