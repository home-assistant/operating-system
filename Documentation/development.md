# Development

## Boot system

`BOOT_SYS`:
- efi
- hyprid
- mbr

HassOS is basicly used GPT. But for use GPT we need own the first 1024 of
boot drive. Is that not possible, you can use MBR for your device, they work also with SPLs.

Hyprid and SPL use both a hyprid MBR/GPT table but SPL move the GPT header 8MB for give space to write SPL and boot images before.

`BOOT_SPL`:
- true
- false

Enable SPL update handling.

`BOOTLOADER`:
- uboot
- barebox

We support mainly uboot but for uefi system we can also use barebox. In future we hope to remove barebox with uboot also on uefi.

`DISK_SIZE`:
Default 2. That is the size of end image in GB.

## Supervisor

`SUPERVISOR_MACHINE`:
- intel-nuc
- odroid-c2
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

`SUPERVISOR_ARCH`
- amd64
- i386
- armhf
- armv7
- aarch64
