#!/bin/sh

## OVA
dtc -@ -I dts -O dtb -o buildroot-external/misc/barebox-state-efi.dtb buildroot-external/misc/barebox-state-efi.dts

