# Raspberry PI

## Supported Hardware

| Device              | Release Date  | Support         | Config             |
|---------------------|---------------|-----------------|--------------------|
| Raspberry Pi 2 B    |2015           | not recommended | [rpi2](../../../buildroot-external/configs/rpi2_defconfig)             |
| Raspberry Pi 3 B/B+ |2016/2018      | yes             | [rpi3](../../../buildroot-external/configs/rpi3_defconfig) / [rpi3_64](../../../buildroot-external/configs/rpi3_64_defconfig) |
| Raspberry Pi 4 B    |2019           | yes             | [rpi4](../../../buildroot-external/configs/rpi4_defconfig) / [rpi4_64](../../../buildroot-external/configs/rpi4_64_defconfig) |
| Raspberry Pi 5      |2023           | yes (beta)      | [rpi5_64](../../../buildroot-external/configs/rpi5_64_defconfig) |

## Serial console

For access to terminal over serial console, add `console=ttyAMA0,115200` to `cmdline.txt` and `enable_uart=1`, `dtoverlay=pi3-disable-bt` into `config.txt`. GPIO pins are: 6 = GND / 8 = UART TXD / 10 = UART RXD.

## I2C

Add `dtparam=i2c1=on` and `dtparam=i2c_arm=on` to `config.txt`. After that we create a module file on host with [config usb stick][config] or direct into `/etc/modules-load.d`.

rpi-i2c.conf:
```
i2c-dev
i2c-bcm2708
```

## USB Boot

USB mass storage boot is available on Raspberry Pi 4 (64-bit only), 3B, 3B+, 3A+, and 2B v1.2.

For Raspberry 3B, 3A+ and 2B v1.2, to enable USB boot, add `program_usb_boot_mode=1` into `config.txt`. Note that this **permanently** alters the one-time programmable memory of the device.

For Raspberry 4

* Make sure to update the bootloader to a stable release supporting USB mass storage boot (see [bcm2711_bootloader_config.md](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711_bootloader_config.md#usbmassstorageboot)). 
* If no SD card is used add `sd_poll_once=on` to `dtparam` in `config.txt` (comma separated). This gets rid of `mmc0: timeout waiting for hardware interrupt` kernel errors.
* If install still fails, then your SSD likely needs quirks enabled to work correctly (see [Finding the VID and PID of your USB SSD](https://www.raspberrypi.org/forums/viewtopic.php?t=245931)). Once you find your adapter's ID, add the quirks parameter in `cmdline.txt`. 

For more information see [RaspberryPi](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/msd.md).

### Caveats

* All bootable SD cards must be removed.
* Boot time can be significantly longer with USB. This is due to the boot process first attempting to boot from SD card, failing, and resorting to USB.
* Many USB drives simply do not work for boot. This is likely due to minimal driver support in uboot and will not be fixed. If you can't get it to boot on one drive, try a different brand/model. SanDisk Cruzer drives seem to have a higher rate of issues.

## Tweaks

If you don't need bluetooth, disabled it with add `dtoverlay=pi3-disable-bt` into `config.txt`.

[config]: ../../configuration.md#automatic
