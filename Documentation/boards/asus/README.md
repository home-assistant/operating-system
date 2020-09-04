# Tinker Board

## Supported Hardware

| Device         | Release Date  | Support | Config   |
|----------------|---------------|---------|----------|
| Tinker RK3288  | April 2017    | yes     | [tinker](../../../buildroot-external/configs/tinker_defconfig) |
| Tinker S RK3288| January 2018  | yes     | [tinker](../../../buildroot-external/configs/tinker_defconfig) |
| Tinker Edge T  | November 2019 | no?     |          |
| Tinker Edge R  | November 2019 | no?     |          |

## eMMC

eMMC support is provided with the same image. Just flash the image to the eMMC by connecting your Tinker Board S to your PC via Micro-USB. Refer to the Tinkerboard documentation how-to flash using Micro-USB and UMS.

The Home Assistant OS provided U-Boot does support UMS as well,
however manual intervention is necessary:

 1. Set the jumper between Micro-USB and HDMI the maskrom mode
 2. Insert SD card and connect the board via Micro-USB to your PC
 3. Continusly press Ctrl+C to interrupt boot
 4. Set the jumper back to the park position
 5. Start UMS using:
```
ums 0 mmc 0
```
 6. A mass storage device should appear. Flash Home Assistant OS to it.

## Serial console

To access the terminal over serial console, add `console=ttyS2,115200` to `cmdline.txt`. GPIO pins are: 34 = GND / 32 = UART TXD / 33 = UART RXD.
