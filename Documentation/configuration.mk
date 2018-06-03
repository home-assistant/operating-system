# Configuration

## Bootargs

You can edit or create a `cmdline.txt` into your boot partition. That will be read from our bootloader.

## Kernel-Module

The kernel module folder `/etc/modules-load.d` is persistent and you can add your config files there. See [Systemd modules load][systemd-modules].


[systemd-modules]: https://www.freedesktop.org/software/systemd/man/modules-load.d.html
