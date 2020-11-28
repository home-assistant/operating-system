RADXA ROCKPI-N8
================
https://wiki.radxa.com/RockpiN8

Build:
======
  $ make rock_pi_n8_defconfig
  $ make

Files created in output directory
=================================

output/images
.
├── boot.vfat
├── extlinux
├── idbloader.img
├── rk3288-rock-pi-n8.dtb
├── rootfs.ext2
├── rootfs.ext4 -> rootfs.ext2
├── rootfs.tar
├── sdcard.img
├── u-boot.bin
├── u-boot-dtb.bin
├── u-boot-dtb.img
└── zImage

Creating bootable SD card:
==========================

Simply invoke (as root)

sudo dd if=output/images/sdcard.img of=/dev/sdX && sync

Where X is your SD card device.

Booting:
========

Serial console:
---------------
RockPi-N8 has a 40-pin GPIO header. The pin layout is as follows:

pin 6:  gnd
pin 8:  tx
pin 10: rx

Baudrate for this board is 115200.

The boot order on rockpi-n8 is emmc, sd. If emmc contains a valid Image, the board
always boots from emmc. To boot from SD, erase emmc as per the guide:

https://wiki.amarulasolutions.com/bsp/setup/rockchip/rk3399_emmc.html

Login:
------
Enter 'root' as login user, and the prompt is ready.

wiki link:
----------
https://wiki.amarulasolutions.com/bsp/rockchip/rk3288/rock-pi-n8.html
