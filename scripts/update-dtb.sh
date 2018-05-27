#!/bin/sh

dtc -I dts -O dtb -o buildroot-external/fdt/barebox-state-efi.dtb buildroot-external/fdt/barebox-state-efi.dts

dtc -@ -I dts -O dtb -o buildroot-external/fdt/barebox-state-rpi.dtbo buildroot-external/fdt/barebox-state-rpi.dtso
