# JetHub H1

More information [JetHub H1 wiki](http://wiki.jethome.ru/jethub_h1) (Russian)

- 4-core CPU Amlogic S905W (ARM Cortex-A53) 1,5 Ghz;
- RAM 1024 MB DDR3;
- eMMC flash 8 Gbyte.

## Interfaces

- WiFi/Bluetooth Realtek RTL8822CS
- MicroSD 2.x/3.x/4.x DS/HS card slot
- Ethernet IEEE 802.3 10/100 Mbps
- ZigBee TI CC2538 + CC2592
- 2 x USB 2.0 high-speed

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
