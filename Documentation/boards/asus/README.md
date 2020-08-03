# Tinker Board

## Supported Hardware

| Device         | Release Date  | Support | Config   |
|----------------|---------------|---------|----------|
| Tinker RK3288  | April 2017    | yes     | [tinker](../../../buildroot-external/configs/tinker_defconfig) |
| Tinker S RK3288| January 2018  | yes?    | [tinker](../../../buildroot-external/configs/tinker_defconfig)? |
| Tinker Edge T  | November 2019 | no?     |          |
| Tinker Edge R  | November 2019 | no?     |          |

(? is the Tinker S supported?)
<!--
## eMMC

eMMC support is provided transparently. Just flash the image to the eMMC by connecting your Tinker Board S to your PC via Micro-USB.
-->

## Serial console

To access the terminal over serial console, add `console=ttyS2,115200` to `cmdline.txt`. GPIO pins are: 34 = GND / 32 = UART TXD / 33 = UART RXD.
