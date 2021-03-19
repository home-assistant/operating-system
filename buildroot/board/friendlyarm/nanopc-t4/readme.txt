FriendlyARM NANOPC-T4
=====================

Build:

  $ make friendlyarm_nanopc_t4_defconfig
  $ make

Files created in output directory
=================================

output/images

├── bl31.elf
├── boot.vfat
├── extlinux
├── idbloader.img
├── Image
├── rk3399-nanopc-t4.dtb
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
Apply power and press the PWR button for 3 sec. Enter 'root' as login user, and the prompt is ready.

https://wiki.amarulasolutions.com/bsp/rockchip/rk3399/npc_t4.html
