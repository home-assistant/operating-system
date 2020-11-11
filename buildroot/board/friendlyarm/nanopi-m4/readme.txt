FriendlyARM NANOPI-M4
=====================

Build:

  $ make nanopi_m4_defconfig
  $ make

Files created in output directory
=================================

output/images

├── bl31.elf
├── boot.vfat
├── extlinux
├── idbloader.img
├── Image
├── rk3399-nanopi-m4.dtb
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

Where X is your SD card device

Serial console
--------------

Baudrate for this board is 1500000

Login:
------
Enter 'root' as login user, and the prompt is ready.

https://wiki.amarulasolutions.com/bsp/rockchip/rk3399/nanopi_m4.html
