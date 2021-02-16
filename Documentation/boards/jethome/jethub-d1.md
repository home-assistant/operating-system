# JetHub D1

More information [JetHub D1 wiki](http://wiki.jethome.ru/jethub_d1) (Russian)

- 4-core CPU Amlogic A113X (ARM Cortex-A53) 1,4 Ghz;
- RAM 512 or 1024 MB DDR3;
- eMMC flash 8 Gbyte.

## Interfaces

- WiFi/Bluetooth AMPAK AP6255 (Broadcom BCM43455)
- Ethernet IEEE 802.3 10/100 Mbps
- ZigBee TI CC2538 + CC2592
- 1 x USB 2.0 high-speed
- 1 X 1-Wire
- 2 x RS-485
- 4 x inputs  «dry contact»
- 3 х relay output

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
