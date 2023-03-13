# ODROID-N2

## eMMC

eMMC support is provided transparently. Just flash the image to the eMMC board as you would an SD card.

## Console

By default, console access is granted over the serial header and over HDMI. Certain startup messages will only appear on the serial console by default. To show the messages on the HDMI console instead, swap the order of the two consoles in the `cmdline.txt` file on the boot partition. You can also delete the AML0 console if you don't plan on using the serial adapter.
eg. `console=ttyAML0,115200n8 console=tty0`

## GPIO

Refer to [the odroid wiki](https://wiki.odroid.com/odroid-n2/hardware/expansion_connectors).
At this point not all functionality is supported by the upstream kernel used
by Home Assistant OS.

The GPIO on pin 11 is used as a low active power button input.
