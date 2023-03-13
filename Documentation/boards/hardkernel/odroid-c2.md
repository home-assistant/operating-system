# ODROID-C2

## eMMC

eMMC support is provided transparently. Just flash the image to the eMMC board as you would an SD card.

## Console

By default, console access is granted over the serial header and over HDMI. Certain startup messages will only appear on the serial console by default. To show the messages on the HDMI console instead, swap the order of the two consoles in the `cmdline.txt` file on the boot partition. You can also delete the AML0 console if you don't plan on using the serial adapter.
eg. `console=ttyAML0,115200n8 console=tty0`

## USB

A long-standing kernel bug currently results in some odd behavior. To use the USB, a device must be plugged into one of the USB ports at hard boot. If all devices are removed from the USB ports, the USB will cease to function until a reboot.

### OTG

The OTG USB is untested.

## GPIO

Refer to [the odroid wiki](https://wiki.odroid.com/odroid-c2/hardware/expansion_connectors).
