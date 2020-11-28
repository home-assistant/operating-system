Mediatek MT8173 aka Chromebook Elm
==================================

This file describes booting the Chromebook from an SD card containing
Buildroot kernel and rootfs, using the original bootloader. This is
the least invasive way to get Buildroot onto the devices and a good
starting point.

The bootloader will only boot a kernel from a GPT partition marked
bootable with cgpt tool from vboot-utils package.
The kernel image must be signed using futility from the same package.
The signing part is done by sign.sh script in this directory.

It does not really matter where rootfs is as long as the kernel is able
to find it, but this particular configuration assumes the kernel is on
partition 1 and rootfs is on partition 2 of the SD card.
Make sure to check kernel.args if you change this.

Making the boot media
---------------------
Start by configuring and building the images.

	make chromebook_elm_defconfig
	make menuconfig # if necessary
	make

The important files are:

	uImage.kpart (kernel and device tree, signed)
	rootfs.tar
	bootsd.img (SD card image containing both kernel and rootfs)

Write the image directly to some SD card.
WARNING: make sure there is nothing important on that card,
and double-check the device name!

	SD=/dev/mmcblk1		# may be /dev/sdX on some hosts
	dd if=output/images/bootsd.img of=$SD

Switching to developer mode and booting from SD
-----------------------------------------------
Power Chromebook down, then power it up while holding Esc+F3.
BEWARE: switching to developer mode deletes all user data.
Create backups if you need them.

While in developer mode, Chromebook will boot into a white screen saying
"OS verification is off".

Press Ctrl-D at this screen to boot Chromium OS from eMMC.
Press Ctrl-U at this screen to boot from SD (or USB)
Press Power to power it off.
Do NOT press Space unless you mean it.
This will switch it back to normal mode.

The is no way to get rid of the white screen without re-flashing the bootloader.

