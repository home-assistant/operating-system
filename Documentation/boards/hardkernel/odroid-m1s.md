# ODROID-M1S

Home Assistant OS 12 and newer support the ODROID-M1S board.

## SD-card

ODROID-M1S can boot HAOS directly from an SD card, as it has higher priority than the system on the eMMC. Simply flash the image to the SD card using your favorite tool and insert it to the micro SD slot on the board. This works even when the eMMC is wiped, or when it contains the factory-default U-Boot SPL loader, which is still able to load U-Boot provided in the HAOS image. In the second case, however, if the SD card fails to probe (e.g. due to a hardware failure), the system on the eMMC may be booted instead of HAOS.

## eMMC

HAOS can be installed directly to the eMMC using a special boot image, to do that:

1. Download the _UMS Utility_ image: [`ODROID-M1S_EMMC2UMS.img`][1]. The _UMS Utility_ is a special image that switches ODROID-M1S to USB Mass Storage device.
2. Use balenaEtcher or another tool to flash the _UMS utility_ onto an SD card.
3. Plug-in that SD card to your ODROID-M1S and boot it. Connect your PC to the Micro USB OTG port.
4. The eMMC will show as a drive on your PC and you can directly flash the HAOS image with balenaEther.

Installing HAOS replaces the firmware and SPL on the eMMC with the mainline version provided by HAOS. As a result, it is not possible to use the SD card with the EMMC2UMS image anymore, because the mainline SPL is not compatible with U-Boot in the EMMC2UMS image at this time (February 2024). This does not pose any problem for standard use, just makes it more complicated in case you want to return to the Hardkernel-provided OS.

A reliable way of reflashing the eMMC in this case is to use HAOS booted from an SD card. To do that, insert the SD card with HAOS to the micro SD slot and plug the board in. Once the device boots to the HA CLI, enter `login` to enter the root shell and use `curl` to download an image and `dd` it to the eMMC block device:

```sh
curl https://dn.odroid.com/RK3566/ODROID-M1S/Installer/ODROID-M1S_EMMC2UMS.img | dd of=/dev/mmcblk0
```

This way the device will start in the UMS mode on the next boot with the SD card removed. Alternatively you can use the [Hardkernel installer image][2] directly instead of the EMMC2UMS image.

## NVMe

Booting directly from NVMe is not supported. The NVMe card can be used as a data disk.

## Technical notes on boot flow

The Home Assistant OS image is bootable by the SoC directly. Refer to the [boot sequence documentation][3] for the details on what part of the boot is executed from the eMMC and what from the SD card. The steps documented above should however cover all scenarios that a standard user may encounter during usage.

## Console

By default, console access is available on the serial header (UART) and on HDMI.
The serial console's baudrate is 1500000 by default.

The systemd startup messages will only appear on the serial console by default.
To show the messages on the HDMI console instead, add the console manually
to the `cmdline.txt` file on the boot partition (e.g. `console=tty0`).

## GPIO

Odroid-M1S introduces a new 14pin expansion header. Refer to [the ODROID wiki][4].
At this point not all functionality is supported by the upstream kernel used by Home Assistant OS.  
Supported modules include:
- UPS
- Internal USB
- Mini IO board (partial support)


[1]: https://dn.odroid.com/RK3566/ODROID-M1S/Installer/ODROID-M1S_EMMC2UMS.img
[2]: https://wiki.odroid.com/odroid-m1s/getting_started/os_installation_guide#user_installer
[3]: https://wiki.odroid.com/odroid-m1s/board_support/boot_sequence
[4]: https://wiki.odroid.com/odroid-m1s/hardware/expansion_connectors
