# ODROID-M1S

Home Assistant OS 12 and newer support the ODROID-M1S board.

## SD-card

SD-card boot is supported only if you have erased Petitboot from eMMC.

## eMMC

To install to eMMC via on-board Petitboot bootloader:

1. Download [`ODROID-M1S_EMMC2UMS.img`][1]
2. Use balenaEtcher or another tool to flash the UMS utility onto an SD card.
3. Plug-in that SD card to your ODROID-M1S and boot it. Connect your PC to the Micro USB OTG port.
4. The eMMC will show as a drive on your PC and you can directly flash the HAOS image with balenaEther.

Installing HAOS erases Petitboot, if you wish to return to any official Hardkernel images then short the maskRom pads near
the 40pin connector while booting from a [Hardkernel recovery image][2].

## NVMe

Booting directly from NVMe is not supported. The NVMe card can be used as a data disk.

## Technical notes on boot flow

The Home Assistant OS image is bootable by the SoC directly. This means that no help from the Hardkernel provided and pre-installed bootloader Petitboot is necessary. Petitboot is stored on the eMMC and will be erased when installing HAOS.

## Console

By default, console access is available on the serial header (UART) and on HDMI.
The serial console's baudrate is 1500000 by default.

The systemd startup messages will only appear on the serial console by default.
To show the messages on the HDMI console instead, add the console manually
to the `cmdline.txt` file on the boot partition (e.g. `console=tty0`).

## GPIO

Odroid-M1S introduces a new 14pin expansion header. Refer to [the odroid wiki][3].
At this point not all functionality is supported by the upstream kernel used by Home Assistant OS.  
Supported modules include:
- UPS
- Internal USB
- Mini IO board (partial support)


[1]: https://dn.odroid.com/RK3566/ODROID-M1S/Installer/ODROID-M1S_EMMC2UMS.img
[2]: https://wiki.odroid.com/odroid-m1s/getting_started/os_installation_guide
[3]: https://wiki.odroid.com/odroid-m1s/hardware/expansion_connectors