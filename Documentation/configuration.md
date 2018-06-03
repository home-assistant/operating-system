# Configuration

## USB

You can format a USB stick with FAT32 and name it with `hassos-config`. The layout could be look like:
```
network/
modules/
known_hosts
hassos-xy.rauc
```

- On `network` folder can hold any kind of NetworkManager connections files.
- The folder `modules` is for modules-load configuration files.
- `known_hosts` file activate debug SSH access of port `22222`.
- For firmware updates you can but the `hassos-*.rauc` OTA update they should be install. 

## Bootargs

You can edit or create a `cmdline.txt` into your boot partition. That will be read from our bootloader.

## Kernel-Module

The kernel module folder `/etc/modules-load.d` is persistent and you can add your config files there. See [Systemd modules load][systemd-modules].


[systemd-modules]: https://www.freedesktop.org/software/systemd/man/modules-load.d.html
