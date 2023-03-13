# ODROID-M1

Home Assistant OS 10 and newer support the ODROID-M1 board.

## SD-card

SD-card boot is supported via on-board bootloader (SPL) or recovery button.

## eMMC

eMMC boot is currently only supported via recovery button. eMMC boot via
on-board bootloader will require an update of Petitboot (as of March 13 2023,
this update hasn't been released yet.

## NVMe

Booting directly from NVMe is not supported. The NVMe card can be used as a data disk.

## Technical notes on boot flow

The Home Assistant OS image is bootable by the SoC directly. This means that no help
from the Hardkernel provided and pre-installed bootloader Petitboot is necessary.
However, the ODROID-M1 automatically boots from internal SPI. To boot
directly off the SD-card or eMMC you need to press the recovery button.

The SPI flashed U-Boot SPL tries searches for an U-Boot binary on the SD-card
(and future releases also on the eMMC). This mechanism allows you to boot the Home
Assistant OS U-Boot without pressing the recovery button.

## Console

By default, console access is available on the serial header (CON1) and on HDMI.
The serial console's baudrate is 1500000 by default.

The systemd startup messages will only appear on the serial console by default.
To show the messages on the HDMI console instead, add the console manually
to the `cmdline.txt` file on the boot partition (e.g. `console=tty0`).
