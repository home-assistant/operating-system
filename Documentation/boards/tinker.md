# Tinker Board

Supported Hardware:

| Device | Board | 
|--------|-----------|
| Tinker RK3288 | tinker |
| Tinker S RK3288 |  |

<!--
## eMMC

eMMC support is provided transparently. Just flash the image to the eMMC by connecting your Tinker Board S to your PC via Micro-USB.
-->

## Serial console

To access the terminal over serial console, add `console=ttyS2,115200` to `cmdline.txt`. GPIO pins are: 34 = GND / 32 = UART TXD / 33 = UART RXD.

