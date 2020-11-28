Intro
=====

This is a board configuration for the apu2 platform by PC Engines.

https://pcengines.ch/apu2.htm

Since the apu2 does not have any graphical output, the default configuration
will ensure that the kernel output as well as the login prompt will be sent to
the serial port.

How to build
============

The provided defconfig creates a hybrid isolinux image that can be booted from
either an USB stick or a CD.

    $ make pcengines_apu2_defconfig
    $ make

How to write to an USB stick
============================

Once the build process is finished you will have an image
called "rootfs.iso9660" in the output/images/ directory.

Copy the bootable "rootfs.iso9660" onto the USB stick with "dd":

    $ sudo dd if=output/images/rootfs.iso9660 of=/dev/sdX bs=1M conv=fsync
    $ sudo sync

How to connect to the apu2
==========================

Connect to the DB9 serial port of the apu2 board (either directly or through a
USB adapter) with a baudrate of 115200.

For example with miniterm (part of pyserial):

    $ miniterm.py -f direct /dev/ttyUSB0 115200
