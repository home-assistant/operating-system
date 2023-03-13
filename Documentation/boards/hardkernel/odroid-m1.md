# ODROID-M1

Home Assistant OS 10 and newer support the ODROID-M1 board.

## SD-card

SD-card boot is supported via on-board bootloader (SPL) or recovery button.

## eMMC

eMMC boot is currently only supported via recovery button. eMMC boot via
on-board bootloader will require an update of Petitboot (as of March 13 2023,
this update hasn't been released yet.

## NVMe

Booting directly from NVMe is not supported. Using the NVMe as the data disk has
been successfully tested.

## Technical notes on boot flow

The Home Assistant OS image is bootable by the SoC directly, that means no help
from the Hardkernel provided and pre-installed bootloader Petitboot is necessary.
However, since the ODROID-M1 boots from internal SPI automatically, booting
directly off the SD-card or eMMC requires pressing the recovery button.

The SPI flashed U-Boot SPL tries searches for an U-Boot binary on the SD-card
(and future releases also on the eMMC). This mechanism allows to boot the Home
Assistant OS U-Boot without the need to press the recovery button.

## Console

By default, console access is available on the serial header (CON1) and on HDMI.
The serial console's baudrate is 1500000 by default.

The systemd startup messages will only appear on the serial console by default.
To show the messages on the HDMI console instead, add the console manually
to the `cmdline.txt` file on the boot partition (e.g. `console=tty0`).
