# Configuration

## Automatic

You can format a USB stick with FAT32/EXT4 and name it with `config`. The layout could be look like:
```
network/
modules/
authorized_keys
hassos-xy.raucb
```

- On `network` folder can hold any kind of NetworkManager connections files.
- The folder `modules` is for modules-load configuration files.
- `authorized_keys` file activate debug SSH access of port `22222`.
- For firmware updates you can but the `hassos-*.raucb` OTA update they should be install.

You can put this USB stick into device and they will be read on startup. You can also trigger this process later over the
API/UI or call `systemctl restart hassos-config` on host.

## Local

### Bootargs

You can edit or create a `cmdline.txt` into your boot partition. That will be read from our bootloader.

### Kernel-Module

The kernel module folder `/etc/modules-load.d` is persistent and you can add your config files there. See [Systemd modules load][systemd-modules].

### Network

You can manual add, edit or remove connections configs from `/etc/NetworkManager/system-connections`.

[systemd-modules]: https://www.freedesktop.org/software/systemd/man/modules-load.d.html
