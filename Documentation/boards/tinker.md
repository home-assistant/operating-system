# Tinker Board

Supported Hardware:

| Device | Board | 
|--------|-----------|
| Tinker RK3288 | tinker |
| Tinker S RK3288 | tinker |

## EMMC

Actual we support only SD cards. The support for EMMC will follow.

## Serial console

For access to terminal over serial console, add `console=ttyS2,115200` to `cmdline.txt`. GPIO pins are: 34 = GND / 32 = UART TXD / 33 = UART RXD.

