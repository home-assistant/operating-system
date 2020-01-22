# Odroid-N2

## eMMC

eMMC support is provided transparently. Just flash the image to the eMMC board as you would an SD card.

## MicroSD Card

If you want use Hassos on microSD card you must flash image on card and then insert it to Odroid N2 slot and switch from SPI to MMC. Only if you select switch on MMC you can boot hassos.

## Console

By default, console access is granted over the serial header and over HDMI. Certain startup messages will only appear on the serial console by default. To show the messages on the HDMI console instead, swap the order of the two consoles in the `cmdline.txt` file on the boot partition. You can also delete the AML0 console if you don't plan on using the serial adapter.
eg. `console=ttyAML0,115200n8 console=tty0`

## GPIO

Refer to [the odroid wiki](https://wiki.odroid.com/odroid-n2/hardware/expansion_connectors).
