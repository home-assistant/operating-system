#!/bin/sh

## OVA
dtc -@ -I dts -O dtb -o buildroot-external/bootloader/barebox-state-efi.dtb buildroot-external/bootloader/barebox-state-efi.dts

