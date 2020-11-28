PINE64 ROCKPro64
================
https://www.pine64.org/rockpro64/

Build:
======
  $ make rockpro64_defconfig
  $ make

Files created in output directory
=================================

output/images

├── bl31.elf
├── boot.vfat
├── extlinux
├── idbloader.img
├── Image
├── rk3399-rockpro64.dtb
├── rootfs.ext2
├── rootfs.ext4 -> rootfs.ext2
├── rootfs.tar
├── sdcard.img
├── u-boot.bin
└── u-boot.itb

Creating bootable SD card:
==========================

Simply invoke (as root)

sudo dd if=output/images/sdcard.img of=/dev/sdX && sync

Where X is your SD card device.

Booting:
========
RockPro64 has a 40-pin PI-2 GPIO Bus.

Connect a jumper between pin 23 and pin 25 for SD card boot.

Serial console:
---------------
The pin layout for serial console on PI-2 GPIO Bus is as follows:

pin 6:  gnd
pin 8:  tx
pin 10: rx

Initially connect pin 6 and pin 8(transmit). Apply power to RockPro64, once the
power is on then connect pin 10(receive).

Baudrate for this board is 1500000.

Login:
------
Enter 'root' as login user, and the prompt is ready.

https://wiki.amarulasolutions.com/bsp/rockchip/rk3399/rockpro64.html
