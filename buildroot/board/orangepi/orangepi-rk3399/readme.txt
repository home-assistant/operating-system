Orangepi Rk3399
================
http://www.orangepi.org/Orange%20Pi%20RK3399/

Build:
======
  $ make orangepi_rk3399_defconfig
  $ make

Files created in output directory
=================================

output/images

├── bl31.elf
├── boot.vfat
├── extlinux
├── idbloader.img
├── Image
├── rk3399-orangepi.dtb
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
Orangepi-RK3399 by default boots from emmc. For SD card boot to
happen, emmc should be empty. If emmc happens to have any bootable
image then erase emmc so that bootrom will look for a proper image in SD.

emmc can be erased once after booted into linux as shown in below link.

https://wiki.amarulasolutions.com/bsp/setup/rockchip/rk3399_emmc.html

Serial console:
---------------

Baudrate for this board is 1500000.

Login:
------
Enter 'root' as login user, and the prompt is ready.

https://wiki.amarulasolutions.com/bsp/rockchip/rk3399/orangepi.html
