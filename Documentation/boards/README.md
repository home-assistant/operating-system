# Boards

## Overview

The following boards/devices are supported:

- Raspberry Pi
  - Pi 4 Model B (1 GB, 2 GB, 4 GB and 8 GB model) 64-bit (recommended)
  - Pi 4 Model B (1 GB, 2 GB, 4 GB and 8 GB model) 32-bit
  - Pi 3 Model B and B+ 64-bit (recommended)
  - Pi 3 Model B and B+ 32-bit
  - Pi 2 (not recommended)
  - Pi Zero-W (not recommended)
  - Pi (not recommended)
- Hardkernel
  - Odroid-N2
  - Odroid-N2+
  - Odroid-C2
  - Odroid-C4
  - Odroid-XU4
- Asus
  - Tinker Board
- Generic x86-64 (UEFI, not suited for virtualization)
  - Intel NUC5CPYH
  - Intel NUC6CAYH
  - Intel NUC10I3FNK2
  - Gigabyte GB-BPCE-3455
  - Computers supporting x86-64 architecture and UEFI boot should generally work
- Virtual appliance (x86_64/UEFI):
  - VMDK
  - OVA ?
  - VHDX ?
  - VDI ?
  - QCOW2 ?

Notes:
  - see ? above: are these currently supported? see ova documentation which explains issues with previous OVA distribution)

## Board specifics

|Board|Build|Config|Docs|
|-----|----|------|----|
|Pi4B 64-bit   |`make rpi4_64`       |[rpi4_64](../../buildroot-external/configs/rpi4_64_defconfig)|[raspberrypi](./raspberrypi/)|
|Pi4B 32-bit   |`make rpi4`          |[rpi4](../../buildroot-external/configs/rpi4_defconfig)|[raspberrypi](./raspberrypi/)|
|Pi3B 64-bit   |`make rpi3_64`       |[rpi3_64](../../buildroot-external/configs/rpi3_64_defconfig)|[raspberrypi](./raspberrypi/)|
|Pi3B 32-bit   |`make rpi3`          |[rpi3](../../buildroot-external/configs/rpi3_defconfig)|[raspberrypi](./raspberrypi/)|
|Pi2           |`make rpi2`          |[rpi2](../../buildroot-external/configs/rpi2_defconfig)|[raspberrypi](./raspberrypi/)|
|Odroid-N2/N2+ |`make odroid_n2`     |[odroid_n2](../../buildroot-external/configs/odroid_n2_defconfig)|[hardkernel](./hardkernel/)|
|Odroid-C2     |`make odroid_c2`     |[odroid_c2](../../buildroot-external/configs/odroid_c2_defconfig)|[hardkernel](./hardkernel/)|
|Odroid-C4     |`make odroid_c4`     |[odroid_c4](../../buildroot-external/configs/odroid_c4_defconfig)|[hardkernel](./hardkernel/)|
|Odroid-XU4    |`make odroid_xu4`    |[odroid_xu4](../../buildroot-external/configs/odroid_xu4_defconfig)|[hardkernel](./hardkernel/)|
|Tinker Board  |`make tinker`        |[tinker](../../buildroot-external/configs/tinker_defconfig)|[asus](./asus/)|
|Generic x86-64|`make generic_x86_64`|[generic_x86_64](../../buildroot-external/configs/generic_x86_64_defconfig)|[generic-x86-64](./generic-x86-64/)|
|OVA           |`make ova`           |[ova](../../buildroot-external/configs/ova_defconfig)|[ova](./ova/)|
