***************************
Freescale i.MX8MN EVK board
***************************

This file documents the Buildroot support for the i.MX8M Nano EVK board.

Build
=====

First, configure Buildroot for the i.MX8MN EVK board:

  make freescale_imx8mnevk_defconfig

Build all components:

  make

You will find in output/images/ the following files:
  - bl31.bin
  - boot.vfat
  - ddr4_201810_fw.bin
  - ddr_fw.bin
  - fsl-imx8mn-ddr4-evk.dtb
  - Image
  - imx8-boot-sd.bin
  - rootfs.ext2
  - rootfs.ext4
  - rootfs.tar
  - sdcard.img
  - u-boot.bin
  - u-boot.imx
  - u-boot.itb
  - u-boot-nodtb.bin
  - u-boot-spl.bin
  - u-boot-spl-ddr.bin

Create a bootable SD card
=========================

To determine the device associated to the SD card have a look in the
/proc/partitions file:

  cat /proc/partitions

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on a SD card. Launch the following
command as root:

  dd if=output/images/sdcard.img of=/dev/<your-sd-device>

*** WARNING! This will destroy all the card content. Use with care! ***

For details about the medium image layout, see the definition in
board/freescale/common/imx/genimage.cfg.template_imx8.

Boot the i.MX8MN EVK board
==========================

To boot your newly created system (refer to the i.MX8MNano EVK Quick Start Guide
[1] for guidance):
- insert the SD card in the SD slot of the board;
- Configure the switches as follows (X = "don't care"):
SW1101:	1100XXXXXX [D1-D10]
SW1102:	XXXXXXXXXX [D1-D10]
- put a micro USB cable into the Debug USB Port and connect using a terminal
  emulator at 115200 bps, 8n1;
- power on the board.

Enjoy!

References
==========
[1] https://www.nxp.com/design/development-boards/i-mx-evaluation-and-development-boards/evaluation-kit-for-the-i-mx-8m-nano-applications-processor:8MNANOD4-EVK
