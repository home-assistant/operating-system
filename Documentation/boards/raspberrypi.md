# Raspberry PI

Supported Hardware:

| Device | Board | 
|--------|-----------|
| Raspberry Pi A+/B/B+| rpi |
| Raspberry Pi Zero | rpi |
| Raspberry Pi Zero W | rpi0-w |
| Raspberry Pi 2 B | rpi2 |
| Raspberry Pi 3 B/B+ | rpi3 / rpi3-64 |

## Serial console

For access to terminal over serial console, add `console=ttyAMA0,115200` to `cmdline.txt` and `enable_uart=1` into `config.txt`.

## Tweaks

If you don't need bluetooth, disabled it with add `dtoverlay=pi3-disable-bt` into `config.txt`.
