# Raspberry PI

Supported Hardware:

| Device | Board | 
|--------|-----------|
| Raspberry Pi A+/B/B+| rpi |
| Raspberry Pi Zero | rpi |
| Raspberry Pi Zero W | rpi0-w |
| Raspberry Pi 2 B | rpi2 |
| Raspberry Pi 3 B/B+ | rpi3 / rpi3-64 |
| Raspberry Pi 4 B | rpi4 / rpi4-64 |

## Limitation 64bit

The 64bit version is under development by RPi-Team. It work very nice but it could have some impacts. Actual we see that the SDcard access with ext4 are a bit slower than on 32bit.

## Serial console

For access to terminal over serial console, add `console=ttyAMA0,115200` to `cmdline.txt` and `enable_uart=1`, `dtoverlay=pi3-disable-bt` into `config.txt`. GPIO pins are: 6 = GND / 8 = UART TXD / 10 = UART RXD.

## I2C

Add `dtparam=i2c1=on` and `dtparam=i2c_arm=on` to `config.txt`. After that we create a module file on host with [config usb stick][config] or direct into `/etc/modules-load.d`. 

rpi-i2c.conf:
```
i2c-dev
i2c-bcm2708
```

## Tweaks

If you don't need bluetooth, disabled it with add `dtoverlay=pi3-disable-bt` into `config.txt`.

[config]: ../configuration.md#automatic
