# ODROID-M1

Home Assistant OS 10 and newer support the ODROID-M1 board.

## SD-card

SD-card boot is supported via on-board bootloader (SPL) or recovery button.

## eMMC

eMMC boot via on-board bootloader requires a newer version of Petitboot
(spiboot 20230328 or later). To install the latest version download the SPI boot image
from [linuxfactory.or.kr][1] as follows:

1. Download `spiupdate_odroidm1_20240415.img.xz`
2. Use balenaEtcher or another tool to flash the updater onto an SD card
3. Download `spiboot-20240109.img`
4. Rename the `spiboot-20240109.img` file to`spiboot.img`.
5. Paste the `spiboot.img` file onto the FAT partition of that same SD card.
6. Plug-in that SD card to your ODROID-M1. Petitboot will update itself, you can verify the progress on the HDMI output.
7. If you see the version 20240109 in the top left corner, the installation was successful.\
   If you see any other version there, the installation failed.

Once Petitboot is updated you can flash Home Assistant OS directly onto an eMMC.

## NVMe

Booting directly from NVMe is not supported. The NVMe card can be used as a data disk.

## Technical notes on boot flow

The Home Assistant OS image is bootable by the SoC directly. This means that no help
from the Hardkernel provided and pre-installed bootloader Petitboot is necessary.
However, the ODROID-M1 automatically boots from internal SPI. To boot
directly off the SD-card or eMMC you need to press the recovery button.

The SPI flashed U-Boot SPL tries searches for an U-Boot binary on the SD-card
(and from eMMC with Petitboot 20230328 and later). This mechanism allows you to
boot the Home Assistant OS U-Boot without pressing the recovery button.

## Console

By default, console access is available on the serial header (CON1) and on HDMI.
The serial console's baudrate is 1500000 by default.

The systemd startup messages will only appear on the serial console by default.
To show the messages on the HDMI console instead, add the console manually
to the `cmdline.txt` file on the boot partition (e.g. `console=tty0`).

[1]: http://ppa.linuxfactory.or.kr/images/petitboot/odroidm1/
