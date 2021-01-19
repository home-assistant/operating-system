# JetHub D1

## MMC

MMC support is provided transparently. Just flash the image to the MMC board by http://update.jethome.ru/armbian/USB_Burning_Tool_v2.2.3.zip

## Console

By default, console access is granted over the serial header. Certain startup messages will only appear on the serial console by default. 

## USB

A long-standing kernel bug currently results in some odd behavior. To use the USB, a device must be plugged into one of the USB ports at hard boot. If all devices are removed from the USB ports, the USB will cease to function until a reboot.

### OTG

The OTG USB is untested.

## GPIO

Work in progress

## MMC

Uboot has MBR partition table autogeneration.
