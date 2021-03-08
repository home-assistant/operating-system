SiFive HiFive Unleashed
=======================

This file describes how to use the pre-defined Buildroot
configuration for the SiFive HiFive Unleashed board.

Further information about the HiFive Unleashed board can be found
at https://www.sifive.com/boards/hifive-unleashed

Building
========

Configure Buildroot using the default board configuration:

  $ make hifive_unleashed_defconfig

Customise the build as necessary:

  $ make menuconfig

Start the build:

  $ make

Result of the build
===================

Once the build has finished you will have the following files:

    output/images/
    +-- boot.scr
    +-- fw_dynamic.bin
    +-- fw_dynamic.elf
    +-- fw_jump.bin
    +-- fw_jump.elf
    +-- hifive-unleashed-a00.dtb
    +-- Image
    +-- rootfs.cpio
    +-- rootfs.ext2
    +-- rootfs.ext4
    +-- rootfs.tar
    +-- sdcard.img
    +-- u-boot.bin
    +-- u-boot.itb
    +-- u-boot-spl.bin


Creating a bootable SD card with genimage
=========================================

By default Buildroot builds a SD card image for you. All you need to do
is dd the image to your SD card, which can be done with the following
command on your development host:

  $ sudo dd if=output/images/sdcard.img of=/dev/sdb bs=4096

The above example command assumes the SD card is accessed via a USB card
reader and shows up as /dev/sdb on the host. Adjust it accordingly per
your actual setup.

Booting the SD card on the board
================================

Make sure that the all DIP switches are set to the off position for
default boot mode (MSEL mode = 1011), insert the SD card and power
up the board.

Connect the USB cable and open minicom (/dev/ttyUSB1, 115200, 8N1).

See the 'SiFive HiFive Unleashed Getting Started Guide' for
more details (https://www.sifive.com/documentation).

You will get a warning reported by fdisk when you examine the SD card.
This is because the genimage_sdcard.cfg file doesn't specify the SD card
size (as people will naturally have different sized cards), so the
secondary GPT header is placed after the rootfs rather than at the end
of the disk where it is expected to be.

You will see something like this at boot time:

[    0.989458] mmc0: host does not support reading read-only switch, assuming write-enable
[    0.996772] mmc0: new SDHC card on SPI
[    1.001634] mmcblk0: mmc0:0000 SD8GB 7.28 GiB
[    1.038079] GPT:Primary header thinks Alt. header is not at the end of the disk.
[    1.044759] GPT:52389 != 15264767
[    1.048051] GPT:Alternate GPT header not at the end of the disk.
[    1.054015] GPT:52389 != 15264767
[    1.057323] GPT: Use GNU Parted to correct GPT errors.
[    1.062479]  mmcblk0: p1 p2 p3


Creating a bootable SPI flash with genimage
===========================================

Adjust Buildroot configuration by:

  $ make menuconfig

Change "System configuration" -> "Extra arguments passed to custom scripts"
value to "-c board/sifive/hifive-unleashed/genimage_spi-nor.cfg", save the
configuration and build. This creates a output/images/spi-nor.img that can
be programmed to the on-board SPI flash.

Boot the board from the SD card prepared above, stop the U-Boot auto boot,
and type the following commands to program the whole SPI flash:

  => tftp 82000000 output/images/spi-nor.img
  => sf probe
  => sf update 82000000 0 2000000

Booting the SPI flash on the board
==================================

Make sure that the all DIP switches are set to the off position for
default boot mode (MSEL mode = 0110) to boot from SPI flash.
