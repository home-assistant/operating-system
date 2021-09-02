STM32F469 Discovery
===================

This tutorial describes how to use the predefined Buildroot
configuration for the STM32F469 Discovery evaluation platform.

Building
--------

  make stm32f469_disco_defconfig
  make

Flashing
--------

  ./board/stmicroelectronics/stm32f469-disco/flash.sh output/

It will flash the U-boot bootloader.

Creating SD card
----------------

Buildroot prepares an"sdcard.img" image in the output/images/ directory,
ready to be dumped on a SD card. Launch the following command as root:

  dd if=output/images/sdcard.img of=/dev/<your-sd-device>

*** WARNING! This will destroy all the card content. Use with care! ***

For details about the medium image layout and its content, see the
definition in board/stmicroelectronics/stm32f469-disco/genimage.cfg.
