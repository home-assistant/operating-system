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
Partition scheme
num|begin  |sectors |bytes        |mbytes|partition|id         |
1  |0      |8192    |4 194 304    |4     |         |00000000-01|
2  |73728  |131072  |67 108 864   |64    |         |00000000-02|
3  |221184 |0       |0            |0     |         |00000000-03|
4  |221184 |13426688|6 874 464 256|6 556 |ext mbr  |00000000-04|
5  |237568 |16384   |8 388 608    |8     |         |00000000-05|
6  |270336 |65536   |33 554 432   |32    |boot     |00000000-06|
7  |352256 |65536   |33 554 432   |32    |kernela  |00000000-07|
8  |434176 |524288  |268 435 456  |256   |systema  |00000000-08|
9  |974848 |65536   |33 554 432   |32    |kernelb  |00000000-09|
10 |1056768|524288  |268 435 456  |256   |systemb  |00000000-0a|
11 |1597440|16384   |8 388 608    |8     |bootinfo |00000000-0b|
12 |1630208|196608  |100 663 296  |96    |overlay  |00000000-0c|
13 |1843200|13426688|6 874 464 256|6 556 |data     |00000000-0d|
