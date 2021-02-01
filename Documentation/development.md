# Development

## Boot system

`BOOT_SYS`:

- efi
- hybrid
- mbr

HassOS is using GPT. But to use GPT we need own the first 1024 of boot drive. Is that's not possible, you can use MBR for your device. This also work with SPLs.

Hybrid and SPL use both a hybrid MBR/GPT table but SPL move the GPT header 8 MB for give space to write SPL and boot images before.

`BOOT_SPL`:

- true
- false

Enable SPL update handling.

`BOOTLOADER`:

- U-Boot
- barebox

We support mainly U-Boot but for UEFI systems we can also use [barebox](https://barebox.org/). In the future, we hope to remove barebox with U-Boot also on UEFI.

`DISK_SIZE`:

Default 2. That is the size of end image in GB.

## Supervisor

`SUPERVISOR_MACHINE`:

- intel-nuc
- odroid-c2
- odroid-c4
- odroid-n2
- odroid-xu
- qemuarm
- qemuarm-64
- qemux86
- qemux86-64
- raspberrypi
- raspberrypi2
- raspberrypi3
- raspberrypi4
- raspberrypi3-64
- raspberrypi4-64
- tinker
- jethub-d1
- jethub-h1

`SUPERVISOR_ARCH`:

- amd64
- i386
- armhf
- armv7
- aarch64
