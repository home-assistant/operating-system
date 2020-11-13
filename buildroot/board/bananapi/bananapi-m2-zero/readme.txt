Intro
=====

This default configuration will allow you to start experimenting with the
Buildroot environment for the Bananapi M2 Zero. With the current configuration
it will bring-up the board, and allow access through the serial console.

Bananapi M2 Zero link:
http://www.banana-pi.org/m2z.html

This configuration uses U-Boot mainline and kernel mainline.

How to build
============

  $ make bananapi_m2_zero_defconfig
  $ make

Note: you will need access to the internet to download the required
sources.

How to write the SD card
========================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX
  $ sync

Insert the micro SDcard in your Bananapi M2 Zero and power it up. The console
is on the Debug UART on the CON3 header, with serial settings 115200 8N1.
