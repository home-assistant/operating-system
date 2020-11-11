RADXA ROCKPI-N10
================
https://wiki.radxa.com/RockpiN10

Build:
======
  $ make rock_pi_n10_defconfig
  $ make

Files created in output directory
=================================

output/images
.
├── bl31.elf
├── boot.vfat
├── extlinux
├── idbloader.img
├── Image
├── rk3399pro-rock-pi-n10.dtb
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

Serial console:
---------------
RockPi-N10 has a 40-pin GPIO header. The pin layout is as follows:

pin 6:  gnd
pin 8:  tx
pin 10: rx

Baudrate for this board is 1500000.

The boot order on rockpi-n10 is emmc, sd. If emmc contains a valid Image, the board
always boots from emmc. To boot from SD, erase emmc as per the guide:

https://wiki.amarulasolutions.com/bsp/setup/rockchip/rk3399_emmc.html

Login:
------
Enter 'root' as login user, and the prompt is ready.

wiki link:
----------
https://wiki.amarulasolutions.com/bsp/rockchip/rk3399pro/rock-pi-n10.html
