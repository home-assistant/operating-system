OLPC XO Laptops
===============

This document explains how to build and run images that run on the OLPC
XO laptops.

Supported models
----------------

* OLPC XO-1
  The original NS Geode based OLPC laptop, uses the x86 architecture.
  Can be booted either from an internal MTD device formatted with JFFS2
  or from a FAT or EXT4 partition on a SD card or a USB flash stick.

* OLPC XO-7.5
  The ARM-based laptop. Needs a recent enough firmware to provide a good
  enough flattened device tree to the kernel. Can be from a FAT or EXT4
  partition on a internal eMMC, a SD card or a USB flash stick.

Configure and build
===================

  $ make olpc_xo1_defconfig   # Configure for XO-1

or:

  $ make olpc_xo175_defconfig # Configure for XO-1.75

Then:

  $ make menuconfig           # Customize the build configuration
  $ make                      # Build

Preparing the machine
=====================

Firmware security
-----------------

Most OLPC machines were shipped with the security system that disallows
booting unsigned software. If this is the case with your machine, in order
to run the image you've built on it you'll need to get a developer key and
deactivate the security system.

The procedure is descriped in the OLPC wiki:
http://wiki.laptop.org/go/Activation_and_Developer_Keys

Firmware upgrade
----------------

It is always preferrable to use an up to date firmware. The firmware images
are available at http://wiki.laptop.org/go/Firmware. For the XO-1.75 laptop
to boot the mainline kernel a firmware Q4E00JA or newer is needed. You can
get it at http://dev.laptop.org/~quozl/q4e00ja.rom.

To update the firmware, place the .rom file on to your bootable media,
connect a charged battery pack and a wall adapter, and enter the Open
Firmware prompt by pressing ESC during the early boot (needs an unlocked
laptop -- see "Firmware security" above). Then use the "flash" command
to update the firmware:

  ok flash ext:\q4e00ja.rom   \ Flash the "q4e00ja.rom" from the SD card
  ok flash u:\q4e00ja.rom     \ Flash the "q4e00ja.rom" from USB stick

Create the bootable SD card or USB flash stick
==============================================

When the build is finished, an image file called "sdcard.img" will be created.
It is suitable for writing directly to a SD card, USB flash stick or (on a
XO-1.75) the internal eMMC flash.

Before writing the image, please double check that you're using the right
device (e.g. with "lsblk" command). Doing the following will DESTROY ALL DATA
that's currently on the media.

  # cat output/images/sdcard.img >/dev/<device>

Flashing the JFFS2 image (XO-1 only)
====================================

Unlike XO-1.75, the internal NAND flash on XO-1 is accessed without a
FTL and needs a flash-friendly filesystem. A build configured for XO-1
creates a file named "root.jffs2" that can be written to it.

One way to write it is from the Open Firmware prompt. First, partition
and format a USB flash disk with a FAT file system and place the
"root.jffs2" file onto it. Then power on the machine, enter the
Open Firmware port by pressing the ESC key and run the following:

  ok patch noop ?open-crcs copy-nand  \ Disable CRC check
  ok copy-nand u:\root.jffs2

Booting the machine
===================

Once your machine is unlocked, it will automatically boot from your media
wherever it will detect it attached to the USB bus or the SD card slot,
otherwise it will proceed booting from the internal flash.
