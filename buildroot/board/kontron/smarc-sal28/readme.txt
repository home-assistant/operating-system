Kontron SMARC-sAL28
===================

How to build it
===============

Configure Buildroot:

  $ make kontron_smarc_sal28_defconfig

Change settings to fit your needs (optional):

  $ make menuconfig

Compile everything and build the rootfs image:

  $ make

Copying the image to a storage device
=====================================

Buildroot builds an image which can be written to the internal eMMC
storage, a SD card or an USB thumb drive. You can use the following
command on your host:

  $ sudo dd if=output/images/sdcard-emmc.img of=/dev/sdx bs=1M

Where /dev/sdx is the corresponding block device of your SD card or USB
thumb drive. To flash it on your internal eMMC use the following command on
the board:

  # dd if=sdcard-emmc.img of=/dev/mmcblk1 bs=1M

Be sure you have not booted from the internal eMMC in this case!

Booting the board
=================

By default the bootloader will search for the first valid image, starting
with the internal eMMC. Consult the vendor documentation on how to use the
DIP switches to select specific boot devices. To use the bootloader
environment set the boot_targets correspondingly. E.g.:

  # setenv boot_targets usb0

To boot from an USB thumb drive.

The device tree is loaded according to the filename in fdtfile. The
following command will set the default device tree, which works on almost
all variants (with less features of course):

  # setenv fdtfile freescale/fsl-ls1028a-kontron-sl28.dtb

Set this to a device tree which fits your board variant.

Connect your serial cable to SER1 and open your favorite terminal emulation
program (baudrate 115200, 8n1). E.g.:

  $ picocom -b 115200 /dev/ttyUSB0

You will get a warning reported by fdisk when you examine the SD card.
This is because the genimage.cfg file doesn't specify the SD card size
(as people will naturally have different sized cards), so the
secondary GPT header is placed after the rootfs rather than at the end
of the disk where it is expected to be.

You will see something like this at boot time:

[    4.552797] GPT:Primary header thinks Alt. header is not at the end of the disk.
[    4.560237] GPT:266272 != 7864319
[    4.563565] GPT:Alternate GPT header not at the end of the disk.
[    4.569596] GPT:266272 != 7864319
[    4.572925] GPT: Use GNU Parted to correct GPT errors.

Updating the bootloader
=======================

Buildroot will automatically build the u-boot bootloader. The resulting
image is called u-boot.rom and you can find it in the images/ directory.

To update the bootloader on the board you could either copy it to an
USB thumb drive or you could put it on a TFTP server. The following
example assumes you have the bootloader image copied to the root of
a thumb drive:

  # usb start
  # load usb 0:1 $loadaddr u-boot.rom
  # sf probe 0 && sf update $fileaddr 0x210000 $filesize
