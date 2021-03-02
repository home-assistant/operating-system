Arrow Avenger96

Intro
=====

This configuration supports the Arrow Avenger96 board:

https://wiki.dh-electronics.com/index.php/Avenger96

How to build
============

 $ make avenger96_defconfig
 $ make

How to write the microSD card
=============================

WARNING! This will destroy all the card content. Use with care!

Once the build process is finished you will have an image called
"sdcard.img" in the output/images/ directory.

Copy the bootable "sdcard.img" onto an microSD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

Boot the board
==============

 (1) Configure the boot switches for boot from microsd: 1-0-1

 (2) Insert the microSD card in the slot

 (3) Plug a serial adapter (beware: 1v8 levels!) to the low speed
     expansion connector

 (4) Plug in power cable

 (5) The system will start, with the console on UART, but also visible
     on the screen.
