# Configuration

## Automatic

You can use a USB drive with HassOS to configure network options, ssh access to the host, and to install updates.
Format a USB stick with FAT32/EXT4/NTFS and name it `CONFIG`. Use the following directory structure within the USB drive:

```
network/
modules/
authorized_keys
hassos-xy.raucb
```

- The `network` folder can contain any kind of NetworkManager connection files. For more information see [Network][network.md]. 
- The `modules` folder is for modules-load configuration files.
- The `authorized_keys` file activates debug SSH access on port `22222`. See [Debugging Hassio][debug-hassio].
- The `hassos-*.raucb` file is a firmware OTA update which will be installed. These can be found on on the [release][hassos-release] page. 

You can put this USB stick into the device and it will be read on startup. You can also trigger this process later over the
API/UI or by calling `systemctl restart hassos-config` on the host.

## Local

### Bootargs

You can edit or create a `cmdline.txt` into your boot partition. That will be read from our bootloader.

### Kernel-Module

The kernel module folder `/etc/modules-load.d` is persistent and you can add your config files there. See [Systemd modules load][systemd-modules].

### Network

You can manual add, edit or remove connections configs from `/etc/NetworkManager/system-connections`.

[systemd-modules]: https://www.freedesktop.org/software/systemd/man/modules-load.d.html
[network.md]: network.md
[hassos-release]: https://github.com/home-assistant/hassos/releases/
[debug-hassio]: https://developers.home-assistant.io/docs/en/hassio_debugging.html
