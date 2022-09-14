# Configuration

## Automatic

You can use an USB drive with HassOS to configure network options, SSH access to the host and to install updates.
Format a USB stick with FAT32/EXT4/NTFS and name it `CONFIG` (in all capitals). Alternative you can create a `CONFIG` folder inside the `boot` partition. Use the following directory structure within the USB drive:

```text
network/
modules/
modprobe/
udev/
authorized_keys
timesyncd.conf
hassos-xy.raucb
```

- The `network` folder can contain any kind of NetworkManager connection files. For more information see [Network][network.md].
- The `modules` folder is for modules-load configuration files.
- The `modprobe` folder is for modules configuration files (/etc/modprobe.d)
- The `udev` folder is for udev rules files.
- The `authorized_keys` file activates debug SSH access on port `22222`. See [Debugging Home Assistant][debug-homeassistant].
- The `timesyncd.conf` file allow you to set different NTP servers. HassOS won't boot without correct working time servers!
- The `hassos-*.raucb` file is a firmware OTA update which will be installed. These can be found on on the [release][hassos-release] page.

Text files that are on USB stick must have Unix (LF) end of line characters. If you create USB stick on Windows machine, be sure to use Notepad++, Visual Studio Code or any other editor, that supports different line endings. In Notepad++ LF EOL can be enabled with setting `Edit -> EOL Conversion -> Unix (LF)`.

You can put this USB stick into the device and it will be read on startup and files written to the correct places. You can also trigger this process later using `ha os import` from the CLI or by calling `systemctl restart hassos-config` on the OS shell. *The USB Stick just needs to be inserted to the device during this setup process and can be removed afterwards.*

## Local

### Bootargs

You can edit or create a `cmdline.txt` in your boot partition. That will be read from the bootloader.

### Kernel-Module

The kernel module folder `/etc/modules-load.d` is persistent and you can add your configuration files there. See [Systemd modules load][systemd-modules]. You can add the modules configuration files in `/etc/modprobe.d` that is also persistent.

### Udev rules

The udev rules folder `/etc/udev/rules.d` is persistent and you can add your configuration files there.

### Network

You can manual add, edit or remove connections configurations from `/etc/NetworkManager/system-connections`.

### NTP

You can manual edit the systemd timesync file on `/etc/systemd/timesyncd.conf`.

Our default NTP configuration look like:

```
[Time]
NTP=time.cloudflare.com
FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org
```

[systemd-modules]: https://www.freedesktop.org/software/systemd/man/modules-load.d.html
[network.md]: network.md
[hassos-release]: https://github.com/home-assistant/hassos/releases/
[debug-homeassistant]: https://developers.home-assistant.io/docs/operating-system/debugging
